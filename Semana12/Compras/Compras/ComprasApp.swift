import SwiftUI
import SwiftData

@main
struct ComprasApp: App {
    // Una sola sesión para toda la app (quién está conectado)
    @State private var sesion = Sesion()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(sesion)      // Todas las pantallas pueden leer la sesión
        }
        // Contenedor de SwiftData: guarda todo en ComprasData.sqlite
        .modelContainer(ContenedorDatos.shared.container)
    }
}
