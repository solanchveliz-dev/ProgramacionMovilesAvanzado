import SwiftUI
import SwiftData

/// Decide qué se muestra: bienvenida, login (sin sesión) o las pestañas del rol (con sesión)
struct RootView: View {
    @Environment(Sesion.self) private var sesion
    @State private var mostrarSplash = true

    var body: some View {
        ZStack {
            Group {
                if let usuario = sesion.usuario {
                    MainTabView(usuario: usuario)
                } else {
                    LoginView()
                }
            }
            .animation(.default, value: sesion.usuario?.persistentModelID)

            if mostrarSplash {
                SplashView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .task {
            // La bienvenida se ve 1.6 segundos al abrir la app
            try? await Task.sleep(for: .seconds(1.6))
            withAnimation(.easeOut(duration: 0.4)) { mostrarSplash = false }
        }
    }
}
