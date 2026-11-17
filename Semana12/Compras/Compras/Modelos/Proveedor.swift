import Foundation
import SwiftData

@Model
final class Proveedor {
    var nombre: String      // Razón social
    var ruc: String         // 11 dígitos, empieza con 10 o 20

    // Un proveedor tiene muchas compras. .deny: no se borra si tiene compras
    @Relationship(deleteRule: .deny, inverse: \Compra.proveedor)
    var compras: [Compra] = []

    init(nombre: String, ruc: String) {
        self.nombre = nombre
        self.ruc = ruc
    }

    // MARK: - Valores calculados desde sus compras (B4)
    /// Compras aprobadas de este proveedor
    var comprasAprobadas: [Compra] {
        compras.filter { $0.estado == EstadoCompra.aprobada.rawValue }
    }

    /// Total comprado (solo compras aprobadas)
    var totalComprado: Double {
        comprasAprobadas.reduce(0) { $0 + $1.total }
    }

    /// Lo que todavía se le debe (compras al crédito no pagadas)
    var deudaPendiente: Double {
        comprasAprobadas.filter { $0.alCredito && !$0.pagada }.reduce(0) { $0 + $1.total }
    }

    var estaAlDia: Bool { deudaPendiente == 0 }
}
