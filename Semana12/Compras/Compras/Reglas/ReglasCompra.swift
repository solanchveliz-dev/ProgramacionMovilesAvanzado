import Foundation
import SwiftData

/// Errores de las operaciones con compras, con el mensaje que ve el usuario
enum ErrorCompra: LocalizedError {
    case datosIncompletos
    case cantidadInvalida
    case costoInvalido
    case motivoVacio
    case noEstaPendiente
    case noEsPorPagar

    var errorDescription: String? {
        switch self {
        case .datosIncompletos: return "Elige un proveedor y un producto."
        case .cantidadInvalida: return "La cantidad debe ser mayor que 0."
        case .costoInvalido: return "El costo unitario debe ser mayor que 0."
        case .motivoVacio: return "Escribe el motivo del rechazo."
        case .noEstaPendiente: return "Esta compra ya no está pendiente."
        case .noEsPorPagar: return "Esta compra no tiene pago pendiente."
        }
    }
}

/// Todas las reglas de negocio de la app en un solo lugar.
/// Las pantallas solo llaman a estas funciones; no calculan nada por su cuenta.
enum ReglasCompra {

    // MARK: - Constantes del negocio
    static let tasaIGV = 0.18                 // RN-01
    static let limiteAprobacion = 5_000.0     // RN-02
    static let diasCredito = 30               // RN-04

    /// Redondea a 2 decimales (céntimos)
    static func redondear(_ valor: Double) -> Double {
        (valor * 100).rounded() / 100
    }

    // MARK: - RN-01 y RN-02 · IGV y aprobación
    struct Calculo {
        let subtotal: Double
        let igv: Double
        let total: Double
        let requiereAprobacion: Bool
    }

    /// Subtotal = cantidad × costo · IGV = 18 % · Total = subtotal + IGV
    static func calcular(cantidad: Int, costoUnitario: Double) -> Calculo {
        let subtotal = redondear(Double(cantidad) * costoUnitario)
        let igv = redondear(subtotal * tasaIGV)
        let total = redondear(subtotal + igv)
        return Calculo(subtotal: subtotal, igv: igv, total: total,
                       requiereAprobacion: total >= limiteAprobacion)
    }

    // MARK: - RN-03 · Costo promedio ponderado
    /// nuevo = (stock × costoPromedio + cantidad × costoUnitario) / (stock + cantidad)
    static func nuevoCostoPromedio(stock: Int, costoPromedio: Double,
                                   cantidad: Int, costoUnitario: Double) -> Double {
        let unidades = stock + cantidad
        guard unidades > 0 else { return costoUnitario }
        let valor = Double(stock) * costoPromedio + Double(cantidad) * costoUnitario
        return redondear(valor / Double(unidades))
    }

    // MARK: - RN-04 · Vencimiento
    static func fechaVencimiento(desde fecha: Date, alCredito: Bool) -> Date {
        guard alCredito else { return fecha }
        return Calendar.current.date(byAdding: .day, value: diasCredito, to: fecha) ?? fecha
    }

    // MARK: - RF-29 · Código correlativo
    static func siguienteCodigo(en contexto: ModelContext) -> String {
        let cantidad = (try? contexto.fetchCount(FetchDescriptor<Compra>())) ?? 0
        return String(format: "OC-%04d", cantidad + 1)
    }

    // MARK: - Efecto de una compra aprobada sobre el producto
    /// Primero se calcula el nuevo costo con el stock ANTERIOR, luego se suma el stock
    static func aplicarEfectos(de compra: Compra) {
        guard let producto = compra.producto else { return }
        producto.costoPromedio = nuevoCostoPromedio(stock: producto.stock,
                                                    costoPromedio: producto.costoPromedio,
                                                    cantidad: compra.cantidad,
                                                    costoUnitario: compra.costoUnitario)
        producto.stock += compra.cantidad
    }

    // MARK: - Operaciones (las usan las pantallas B5, B7 y B8)

    /// B5 · Registra una compra. Si el total es menor a S/ 5,000 queda Aprobada y
    /// actualiza el producto; si no, queda Pendiente y no cambia nada todavía.
    @discardableResult
    static func registrarCompra(cantidad: Int, costoUnitario: Double, alCredito: Bool,
                                fecha: Date = .now, comprador: Usuario?,
                                proveedor: Proveedor?, producto: Producto?,
                                en contexto: ModelContext) throws -> Compra {
        guard proveedor != nil, producto != nil else { throw ErrorCompra.datosIncompletos }
        guard cantidad > 0 else { throw ErrorCompra.cantidadInvalida }
        guard costoUnitario > 0 else { throw ErrorCompra.costoInvalido }

        let calculo = calcular(cantidad: cantidad, costoUnitario: costoUnitario)
        let estado: EstadoCompra = calculo.requiereAprobacion ? .pendiente : .aprobada

        let compra = Compra(
            codigo: siguienteCodigo(en: contexto),
            fecha: fecha,
            cantidad: cantidad,
            costoUnitario: costoUnitario,
            igv: calculo.igv,
            total: calculo.total,
            alCredito: alCredito,
            vence: fechaVencimiento(desde: fecha, alCredito: alCredito),
            estado: estado,
            pagada: !alCredito,                      // Contado = pagada
            comprador: comprador,
            proveedor: proveedor,
            producto: producto
        )
        contexto.insert(compra)

        if estado == .aprobada {
            aplicarEfectos(de: compra)
        }
        try contexto.save()
        return compra
    }

    /// B7 · Aprobar: recién aquí cambian stock, costo promedio y cuentas por pagar
    static func aprobar(_ compra: Compra, en contexto: ModelContext) throws {
        guard compra.estadoCompra == .pendiente else { throw ErrorCompra.noEstaPendiente }
        compra.estado = EstadoCompra.aprobada.rawValue
        aplicarEfectos(de: compra)
        try contexto.save()
    }

    /// B7 · Rechazar: exige motivo y no cambia nada más
    static func rechazar(_ compra: Compra, motivo: String, en contexto: ModelContext) throws {
        let motivoLimpio = motivo.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !motivoLimpio.isEmpty else { throw ErrorCompra.motivoVacio }
        guard compra.estadoCompra == .pendiente else { throw ErrorCompra.noEstaPendiente }
        compra.estado = EstadoCompra.rechazada.rawValue
        compra.motivoRechazo = motivoLimpio
        try contexto.save()
    }

    /// B8 · Pagar (solo supervisor)
    static func pagar(_ compra: Compra, en contexto: ModelContext) throws {
        guard compra.esPorPagar else { throw ErrorCompra.noEsPorPagar }
        compra.pagada = true
        compra.fechaPago = .now
        try contexto.save()
    }

    // MARK: - Validación de RUC (B4)
    /// 11 dígitos que empiezan con 10 (persona natural) o 20 (empresa)
    static func rucValido(_ ruc: String) -> Bool {
        ruc.count == 11 && ruc.allSatisfy(\.isNumber) && (ruc.hasPrefix("10") || ruc.hasPrefix("20"))
    }
}
