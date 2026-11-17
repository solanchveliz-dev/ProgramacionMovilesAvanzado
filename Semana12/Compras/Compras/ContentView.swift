import SwiftUI
import SwiftData

// Pantalla temporal: comprueba que el modelo de datos funciona.
// En los siguientes pasos se reemplaza por el login.
struct ContentView: View {
    @Query private var usuarios: [Usuario]
    @Query private var proveedores: [Proveedor]
    @Query private var productos: [Producto]
    @Query private var compras: [Compra]

    var body: some View {
        NavigationStack {
            List {
                Section("Modelo de datos listo") {
                    LabeledContent("Usuarios", value: "\(usuarios.count)")
                    LabeledContent("Proveedores", value: "\(proveedores.count)")
                    LabeledContent("Productos", value: "\(productos.count)")
                    LabeledContent("Compras", value: "\(compras.count)")
                }
            }
            .navigationTitle("Compras")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
