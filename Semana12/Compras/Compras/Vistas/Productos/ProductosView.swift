import SwiftUI
import SwiftData

/// B3 · Productos
struct ProductosView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var busqueda = ""
    @State private var categoria: String?          // nil = Todos
    @State private var mostrarNuevo = false
    @State private var mensajeBloqueo: String?

    private var esSupervisor: Bool { sesion.usuario?.esSupervisor ?? false }

    // ② Búsqueda + ③ filtro por categoría
    private var filtrados: [Producto] {
        productos.filter { p in
            (categoria == nil || p.categoria == categoria)
            && (busqueda.isEmpty
                || p.nombre.localizedCaseInsensitiveContains(busqueda)
                || p.categoria.localizedCaseInsensitiveContains(busqueda))
        }
    }

    // ④ Valor del inventario = Σ stock × costo promedio
    private var valorInventario: Double { productos.reduce(0) { $0 + $1.valorInventario } }
    private var stockBajo: Int { productos.filter { $0.stock <= 5 }.count }

    var body: some View {
        NavigationStack {
            List {
                // Tarjeta del valor del inventario
                Section {
                    TarjetaDestacada(titulo: "Valor del inventario",
                                     valor: valorInventario.soles,
                                     detalle: "\(productos.count) productos · \(stockBajo) con stock bajo",
                                     icono: "shippingbox.fill")
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // Chips de categoría
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ChipFiltro(titulo: "Todos", seleccionado: categoria == nil) { categoria = nil }
                            ForEach(Categoria.allCases) { c in
                                ChipFiltro(titulo: c.rawValue, icono: c.icono,
                                           seleccionado: categoria == c.rawValue) { categoria = c.rawValue }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // Lista de productos
                Section {
                    if productos.isEmpty {
                        ContentUnavailableView("Sin productos", systemImage: "shippingbox",
                                               description: Text(esSupervisor ? "Toca + para agregar el primero."
                                                                              : "El supervisor aún no registra productos."))
                            .listRowBackground(Color.clear)
                    } else if filtrados.isEmpty {
                        ContentUnavailableView("Sin resultados", systemImage: "magnifyingglass",
                                               description: Text("Prueba con otra búsqueda o categoría."))
                            .listRowBackground(Color.clear)
                    }
                    ForEach(filtrados) { producto in
                        NavigationLink {
                            ProductoDetalleView(producto: producto)
                        } label: {
                            FilaProducto(producto: producto)
                        }
                        .deleteDisabled(!esSupervisor)      // ⑤ Solo el supervisor puede deslizar
                    }
                    .onDelete(perform: borrar)
                } header: {
                    Text(filtrados.count == 1 ? "1 producto" : "\(filtrados.count) productos")
                }
            }
            .listSectionSpacing(14)
            .searchable(text: $busqueda, prompt: "Buscar producto o categoría")
            .navigationTitle("Productos")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if esSupervisor {                       // ① Botón + solo supervisor
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

    /// Borrado bloqueado si el producto tiene compras (.deny)
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

/// Fila de la lista: foto, nombre, categoría, costo promedio, stock en color y valor
struct FilaProducto: View {
    let producto: Producto

    var body: some View {
        HStack(spacing: 12) {
            MiniaturaProducto(foto: producto.foto, categoria: producto.categoria)
            VStack(alignment: .leading, spacing: 3) {
                Text(producto.nombre)
                    .font(.body.weight(.semibold))
                    .lineLimit(1)
                Text(producto.categoria)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Costo prom. \(producto.costoPromedio.soles)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 6) {
                EtiquetaStock(stock: producto.stock)
                Text(producto.valorInventario.soles)
                    .font(.caption.weight(.medium))
                    .monospacedDigit()
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProductosView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
