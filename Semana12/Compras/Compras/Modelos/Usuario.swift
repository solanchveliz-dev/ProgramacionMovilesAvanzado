import Foundation
import SwiftData

/// Roles de la app. Se guarda el rawValue (String) en Usuario.rol.
enum Rol: String, CaseIterable, Identifiable {
    case comprador = "Comprador"
    case supervisor = "Supervisor"
    var id: String { rawValue }
}

@Model
final class Usuario {
    var nombre: String          // Nombre completo
    var usuario: String         // Siempre en minúsculas: así "MTORRES" y "mtorres" son el mismo
    var clave: String           // Hash SHA-256 de (sal + clave). Nunca la clave real
    var sal: String             // Texto aleatorio propio de cada usuario
    var rol: String             // "Comprador" o "Supervisor"
    var fechaRegistro: Date

    // Un usuario tiene muchas compras. .deny: no se puede borrar si tiene compras
    @Relationship(deleteRule: .deny, inverse: \Compra.comprador)
    var compras: [Compra] = []

    init(nombre: String, usuario: String, clave: String, sal: String, rol: Rol, fechaRegistro: Date = .now) {
        self.nombre = nombre
        self.usuario = usuario
        self.clave = clave
        self.sal = sal
        self.rol = rol.rawValue
        self.fechaRegistro = fechaRegistro
    }

    // MARK: - Propiedades calculadas (no se guardan)
    var esSupervisor: Bool { rol == Rol.supervisor.rawValue }

    /// "María Torres" -> "MT" (para el avatar)
    var iniciales: String {
        let partes = nombre.split(separator: " ").prefix(2)
        return partes.compactMap { $0.first.map(String.init) }.joined().uppercased()
    }
}
