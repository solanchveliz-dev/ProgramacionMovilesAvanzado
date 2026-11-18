import SwiftUI

/// Pestañas según el rol de la sesión
struct MainTabView: View {
    let usuario: Usuario

    var body: some View {
        if usuario.esSupervisor {
            // Supervisor: Resumen, Aprobar, Por pagar, Productos, Proveedores
            TabView {
                PantallaPendiente(titulo: "Resumen", icono: "chart.bar.xaxis")
                    .tabItem { Label("Resumen", systemImage: "chart.bar.xaxis") }
                PantallaPendiente(titulo: "Aprobar", icono: "checkmark.seal")
                    .tabItem { Label("Aprobar", systemImage: "checkmark.seal") }
                PantallaPendiente(titulo: "Por pagar", icono: "creditcard")
                    .tabItem { Label("Por pagar", systemImage: "creditcard") }
                ProductosView()
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                PantallaPendiente(titulo: "Proveedores", icono: "building.2")
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
            }
        } else {
            // Comprador: Productos, Proveedores, Compra, Mis compras
            TabView {
                ProductosView()
                    .tabItem { Label("Productos", systemImage: "shippingbox") }
                PantallaPendiente(titulo: "Proveedores", icono: "building.2")
                    .tabItem { Label("Proveedores", systemImage: "building.2") }
                PantallaPendiente(titulo: "Nueva compra", icono: "cart.badge.plus")
                    .tabItem { Label("Compra", systemImage: "cart.badge.plus") }
                PantallaPendiente(titulo: "Mis compras", icono: "list.bullet.rectangle")
                    .tabItem { Label("Mis compras", systemImage: "list.bullet.rectangle") }
            }
        }
    }
}
