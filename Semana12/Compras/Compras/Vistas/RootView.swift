import SwiftUI
import SwiftData

/// Decide qué se muestra: login (sin sesión) o la app (con sesión)
struct RootView: View {
    @Environment(Sesion.self) private var sesion

    var body: some View {
        Group {
            if let usuario = sesion.usuario {
                // (temporal: en el commit 7 se cambia por MainTabView)
                VStack(spacing: 12) {
                    Text("Hola, \(usuario.nombre)").font(.title2.bold())
                    Text("Rol: \(usuario.rol)").foregroundStyle(.secondary)
                    Button("Cerrar sesión") { sesion.cerrar() }
                        .buttonStyle(.bordered)
                }
            } else {
                LoginView()
            }
        }
        .animation(.default, value: sesion.usuario?.persistentModelID)
    }
}
