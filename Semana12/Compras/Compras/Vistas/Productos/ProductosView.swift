import SwiftUI
import SwiftData

/// B3 · Productos (fiel a la maqueta)
struct ProductosView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var mensajeBloqueo: String?

    private var esSupervisor: Bool { sesion.usuario?.esSupervisor ?? false }

    // ② Búsqueda
    private var filtrados: [Producto] {
        guard !busqueda.isEmpty else { return productos }
        return productos.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda)
                || $0.categoria.localizedCaseInsensitiveContains(busqueda)
        }
    }

    // ④ Valor del inventario = Σ stock × costo promedio
    private var valorInventario: Double { productos.reduce(0) { $0 + $1.valorInventario } }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if productos.isEmpty {
                        ContentUnavailableView("Sin productos", systemImage: "shippingbox",
                                               description: Text(esSupervisor ? "Toca + para agregar el primero."
                                                                              : "El supervisor aún no registra productos."))
                            .listRowBackground(Color.clear)
                    } else if filtrados.isEmpty {
                        ContentUnavailableView.search(text: busqueda)
                            .listRowBackground(Color.clear)
                    }
                    ForEach(filtrados) { producto in
                        NavigationLink {
                            ProductoDetalleView(producto: producto)
                        } label: {
                            FilaProducto(producto: producto)          // ③
                        }
                        .deleteDisabled(!esSupervisor)                 // ⑤ solo supervisor
                    }
                    .onDelete(perform: borrar)
                }

                // ④ Valor del inventario
                if !productos.isEmpty {
                    Section {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Valor del inventario (stock × costo promedio)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(valorInventario.soles)
                                .font(.title2.bold())
                                .monospacedDigit()
                        }
                        .padding(.vertical, 4)
                    } footer: {
                        if esSupervisor {
                            Text("Desliza para borrar. No se puede borrar un producto que tiene compras.")
                        }
                    }
                }
            }
            .listSectionSpacing(14)
            .searchable(text: $busqueda, prompt: "Buscar")
            .navigationTitle("Productos")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if esSupervisor {                                  // ① + solo supervisor
                        Button { mostrarNuevo = true } label: { Image(systemName: "plus") }
                            .accessibilityLabel("Nuevo producto")
                    }
                    AvatarMenu()
                }
            }
            .sheet(isPresented: $mostrarNuevo) { ProductoFormView(producto: nil) }
            .alert("No se puede eliminar",
                   isPresented: Binding(get: { mensajeBloqueo != nil }, set: { if !$0 { mensajeBloqueo = nil } })) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text(mensajeBloqueo ?? "")
            }
        }
    }

    /// ⑤ Borrado bloqueado si el producto tiene compras (.deny)
    private func borrar(_ offsets: IndexSet) {
        for index in offsets {
            let producto = filtrados[index]
            guard producto.compras.isEmpty else {
                mensajeBloqueo = "\(producto.nombre) tiene \(producto.compras.count) compra(s) registrada(s). Se conserva para no perder el historial."
                return
            }
            contexto.delete(producto)
        }
        try? contexto.save()
    }
}

/// ③ Fila: foto o iniciales, nombre, categoría, costo promedio y stock en color
struct FilaProducto: View {
    let producto: Producto

    var body: some View {
        HStack(spacing: 12) {
            MiniaturaProducto(foto: producto.foto, categoria: producto.categoria, tamano: 44, nombre: producto.nombre)
            VStack(alignment: .leading, spacing: 2) {
                Text(producto.nombre)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text(producto.categoria)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 6)
            VStack(alignment: .trailing, spacing: 1) {
                Text(producto.costoPromedio.soles)
                    .font(.subheadline.weight(.bold))
                    .monospacedDigit()
                Text("costo prom.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            EtiquetaStock(stock: producto.stock)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ProductosView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
