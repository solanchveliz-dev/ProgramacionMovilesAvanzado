import SwiftUI
import SwiftData

// Pantalla temporal para probar el registro (B2).
// En el siguiente paso se reemplaza por RootView (login).
struct ContentView: View {
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Usuario.fechaRegistro) private var usuarios: [Usuario]

    var body: some View {
        if let usuario = sesion.usuario {
            // Después de registrarse, entra directo a la app
            NavigationStack {
                List {
                    Section("Sesión iniciada") {
                        LabeledContent("Nombre", value: usuario.nombre)
                        LabeledContent("Usuario", value: usuario.usuario)
                        LabeledContent("Rol", value: usuario.rol)
                    }
                    Section("Usuarios registrados (\(usuarios.count))") {
                        ForEach(usuarios) { u in
                            VStack(alignment: .leading) {
                                Text("\(u.nombre) · @\(u.usuario) · \(u.rol)")
                                // Se ve que la clave está guardada como hash, no tal cual
                                Text("clave: \(u.clave.prefix(16))…")
                                    .font(.caption.monospaced())
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    Button("Cerrar sesión", role: .destructive) { sesion.cerrar() }
                }
                .navigationTitle("Compras")
            }
        } else {
            NavigationStack {
                RegistroView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
