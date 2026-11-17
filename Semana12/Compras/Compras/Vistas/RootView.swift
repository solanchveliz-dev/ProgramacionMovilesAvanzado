import SwiftUI
import SwiftData

/// Decide qué se muestra: login (sin sesión) o las pestañas del rol (con sesión)
struct RootView: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        Group {
            if let usuario = sesion.usuario {
                MainTabView(usuario: usuario)
            } else {
                LoginView()
            }
        }
        .animation(.default, value: sesion.usuario?.persistentModelID)
    }
}
