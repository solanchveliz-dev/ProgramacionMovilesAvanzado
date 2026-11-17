import Foundation
import Observation

/// Guarda quién está conectado mientras la app está abierta.
/// Es @Observable: cuando usuario cambia, las vistas que lo leen se redibujan solas.
@Observable
final class Sesion {
    var usuario: Usuario?

    func iniciar(_ usuario: Usuario) {
        self.usuario = usuario
    }

    /// Poner el usuario en nil hace que RootView vuelva al login automáticamente
    func cerrar() {
        usuario = nil
    }
}
