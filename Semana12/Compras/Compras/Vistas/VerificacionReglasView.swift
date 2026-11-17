import SwiftUI

/// Pantalla de verificación (solo para desarrollo): muestra los resultados de las
/// reglas con los números de los casos de prueba de la guía. Se mira en el Preview.
struct VerificacionReglasView: View {
    // Producto base de los casos de prueba: stock 40, costo promedio 110.00
    private let stock = 40
    private let costo = 110.0

    var body: some View {
        let caso3 = ReglasCompra.calcular(cantidad: 10, costoUnitario: 120)
        let costo3 = ReglasCompra.nuevoCostoPromedio(stock: stock, costoPromedio: costo, cantidad: 10, costoUnitario: 120)
        let caso5 = ReglasCompra.calcular(cantidad: 50, costoUnitario: 120)
        let costo6 = ReglasCompra.nuevoCostoPromedio(stock: stock, costoPromedio: costo, cantidad: 50, costoUnitario: 120)
        let borde1 = ReglasCompra.calcular(cantidad: 35, costoUnitario: 121)
        let borde2 = ReglasCompra.calcular(cantidad: 36, costoUnitario: 118)

        List {
            Section("Caso 3 · 10 a S/ 120.00 (esperado 1,200 · 216 · 1,416 · Aprobada · 112.00)") {
                fila("Subtotal", caso3.subtotal.soles)
                fila("IGV", caso3.igv.soles)
                fila("Total", caso3.total.soles)
                fila("Estado", caso3.requiereAprobacion ? "Pendiente" : "Aprobada")
                fila("Nuevo costo promedio", costo3.soles)
                fila("Vence", ReglasCompra.fechaVencimiento(desde: .now, alCredito: true).corta)
            }
            Section("Casos 5 y 6 · 50 a S/ 120.00 (esperado 7,080 · Pendiente · 115.56)") {
                fila("Total", caso5.total.soles)
                fila("Estado", caso5.requiereAprobacion ? "Pendiente" : "Aprobada")
                fila("Costo promedio al aprobar", costo6.soles)
                fila("Stock al aprobar", "\(stock + 50)")
            }
            Section("Caso 11 · Límite de S/ 5,000") {
                fila("35 × 121.00 = \(borde1.total.soles)", borde1.requiereAprobacion ? "Pendiente" : "Aprobada")
                fila("36 × 118.00 = \(borde2.total.soles)", borde2.requiereAprobacion ? "Pendiente" : "Aprobada")
            }
            Section("RUC") {
                fila("20100047218", ReglasCompra.rucValido("20100047218") ? "Válido" : "Inválido")
                fila("12345", ReglasCompra.rucValido("12345") ? "Válido" : "Inválido")
            }
        }
    }

    private func fila(_ titulo: String, _ valor: String) -> some View {
        LabeledContent(titulo, value: valor)
    }
}

#Preview {
    VerificacionReglasView()
}
