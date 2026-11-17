import SwiftUI
import SwiftData

@main
struct ComprasApp: App {
    // Una sola sesión para toda la app
    @State private var sesion = Sesion()

    var body: some Scene {
        WindowGroup {
            RootView()          // Login o app, según la sesión
                .environment(sesion)
        }
        .modelContainer(ContenedorDatos.shared.container)
    }
}
