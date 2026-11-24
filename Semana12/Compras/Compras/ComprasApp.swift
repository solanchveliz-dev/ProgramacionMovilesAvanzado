import SwiftUI
import SwiftData
import UIKit

@main
struct ComprasApp: App {
    // Una sola sesión para toda la app
    @State private var sesion = Sesion()

    init() {
        // Títulos de navegación con letra redondeada (look de app profesional)
        func redondeada(_ tamano: CGFloat, _ peso: UIFont.Weight) -> UIFont {
            let base = UIFont.systemFont(ofSize: tamano, weight: peso)
            guard let descriptor = base.fontDescriptor.withDesign(.rounded) else { return base }
            return UIFont(descriptor: descriptor, size: tamano)
        }
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: redondeada(34, .bold)]
        UINavigationBar.appearance().titleTextAttributes = [.font: redondeada(17, .semibold)]
    }

    var body: some Scene {
        WindowGroup {
            RootView()          // Login o app, según la sesión
                .environment(sesion)
                .tint(.marca)  // Color de marca en toda la app
        }
        .modelContainer(ContenedorDatos.shared.container)
    }
}
