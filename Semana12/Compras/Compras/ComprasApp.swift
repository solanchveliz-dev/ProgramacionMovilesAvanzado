import SwiftUI
import SwiftData

@main
struct ComprasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Contenedor de SwiftData: guarda todo en ComprasData.sqlite
        .modelContainer(ContenedorDatos.shared.container)
    }
}
