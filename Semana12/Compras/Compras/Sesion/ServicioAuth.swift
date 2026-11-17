import Foundation
import SwiftData
import CryptoKit

/// Errores de registro e inicio de sesión, con el mensaje que ve el usuario
enum ErrorAuth: LocalizedError, Equatable {
    case camposVacios
    case usuarioExiste
    case claveCorta
    case clavesNoCoinciden
    case credencialesInvalidas

    var errorDescription: String? {
        switch self {
        case .camposVacios: return "Completa todos los campos."
        case .usuarioExiste: return "Ese usuario ya existe. Elige otro."
        case .claveCorta: return "La clave debe tener al menos 6 caracteres."
        case .clavesNoCoinciden: return "Las claves no coinciden."
        // Mensaje genérico: no dice si falló el usuario o la clave
        case .credencialesInvalidas: return "Usuario o clave incorrectos"
        }
    }
}

/// Reglas de registro e inicio de sesión. No tiene pantallas: las vistas solo lo llaman.
enum ServicioAuth {

    static let longitudMinimaClave = 6

    /// "  MTorres " -> "mtorres"
    static func normalizar(_ usuario: String) -> String {
        usuario.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    // MARK: - Seguridad de la clave
    /// 16 bytes aleatorios en hexadecimal (una sal distinta por usuario)
    static func generarSal() -> String {
        (0..<16).map { _ in String(format: "%02x", UInt8.random(in: 0...255)) }.joined()
    }

    /// SHA-256 de (sal + clave) en hexadecimal
    static func hash(_ clave: String, sal: String) -> String {
        let digest = SHA256.hash(data: Data((sal + clave).utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Consultas
    /// ¿Ya existe ese usuario? (sin distinguir mayúsculas, porque se guarda en minúsculas)
    static func existeUsuario(_ usuario: String, en contexto: ModelContext) -> Bool {
        let buscado = normalizar(usuario)           // se guarda en un let antes del #Predicate
        guard !buscado.isEmpty else { return false }
        let descriptor = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == buscado })
        return ((try? contexto.fetchCount(descriptor)) ?? 0) > 0
    }

    // MARK: - Registro (B2)
    @discardableResult
    static func registrar(nombre: String, usuario: String, clave: String, confirmacion: String,
                          rol: Rol, en contexto: ModelContext) throws -> Usuario {
        let nombreLimpio = nombre.trimmingCharacters(in: .whitespacesAndNewlines)
        let usuarioLimpio = normalizar(usuario)

        guard !nombreLimpio.isEmpty, !usuarioLimpio.isEmpty, !clave.isEmpty else { throw ErrorAuth.camposVacios }
        guard !existeUsuario(usuarioLimpio, en: contexto) else { throw ErrorAuth.usuarioExiste }
        guard clave.count >= longitudMinimaClave else { throw ErrorAuth.claveCorta }
        guard clave == confirmacion else { throw ErrorAuth.clavesNoCoinciden }

        let sal = generarSal()
        let nuevo = Usuario(nombre: nombreLimpio, usuario: usuarioLimpio,
                            clave: hash(clave, sal: sal), sal: sal, rol: rol)
        contexto.insert(nuevo)
        try contexto.save()
        return nuevo
    }

    // MARK: - Inicio de sesión (B1)
    static func iniciarSesion(usuario: String, clave: String, en contexto: ModelContext) throws -> Usuario {
        let buscado = normalizar(usuario)
        let descriptor = FetchDescriptor<Usuario>(predicate: #Predicate { $0.usuario == buscado })

        guard let encontrado = try contexto.fetch(descriptor).first,
              encontrado.clave == hash(clave, sal: encontrado.sal) else {
            throw ErrorAuth.credencialesInvalidas
        }
        return encontrado
    }
}
