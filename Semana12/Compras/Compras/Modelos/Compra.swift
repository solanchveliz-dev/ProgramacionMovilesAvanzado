import Foundation
import SwiftData

/// Estados posibles de una compra (se guarda el rawValue en Compra.estado)
enum EstadoCompra: String, CaseIterable {
    case pendiente = "Pendiente"     // Esperando aprobación del supervisor
    case aprobada = "Aprobada"       // Ya afectó stock y costo promedio
    case rechazada = "Rechazada"     // No afectó nada
}

@Model
final class Compra {
    var codigo: String              // Correlativo: OC-0001, OC-0002...
    var fecha: Date
    var cantidad: Int
    var costoUnitario: Double       // Sin IGV
    var igv: Double                 // 18 % del subtotal (crédito fiscal)
    var total: Double               // Subtotal + IGV
    var alCredito: Bool             // false = contado, true = crédito 30 días
    var vence: Date                 // fecha + 30 días si es al crédito
    var estado: String              // Pendiente, Aprobada o Rechazada
    var pagada: Bool
    var motivoRechazo: String?
    var fechaPago: Date?

    // Lado "uno" de las relaciones (los inversos están en Usuario, Proveedor y Producto)
    var comprador: Usuario?
    var proveedor: Proveedor?
    var producto: Producto?

    init(codigo: String, fecha: Date, cantidad: Int, costoUnitario: Double, igv: Double, total: Double,
         alCredito: Bool, vence: Date, estado: EstadoCompra, pagada: Bool,
         comprador: Usuario?, proveedor: Proveedor?, producto: Producto?) {
        self.codigo = codigo
        self.fecha = fecha
        self.cantidad = cantidad
        self.costoUnitario = costoUnitario
        self.igv = igv
        self.total = total
        self.alCredito = alCredito
        self.vence = vence
        self.estado = estado.rawValue
        self.pagada = pagada
        self.comprador = comprador
        self.proveedor = proveedor
        self.producto = producto
    }

    // MARK: - Calculados
    var subtotal: Double { Double(cantidad) * costoUnitario }
    var estadoCompra: EstadoCompra { EstadoCompra(rawValue: estado) ?? .pendiente }

    /// Aprobada, al crédito, sin pagar y con vencimiento anterior a hoy
    var estaVencida: Bool {
        estadoCompra == .aprobada && alCredito && !pagada
            && vence < Calendar.current.startOfDay(for: .now)
    }

    /// Cuenta por pagar: aprobada, al crédito y sin pagar
    var esPorPagar: Bool { estadoCompra == .aprobada && alCredito && !pagada }
}
