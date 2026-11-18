import SwiftUI
import SwiftData

/// Detalle de un producto con su historial de compras aprobadas
struct ProductoDetalleView: View {
    @Environment(Sesion.self) private var sesion
    let producto: Producto
    @State private var editar = false

    private var historial: [Compra] {
        producto.compras
            .filter { $0.estadoCompra == .aprobada }
            .sorted { $0.fecha > $1.fecha }
    }

    var body: some View {
        List {
            // Encabezado con foto
            Section {
                VStack(spacing: 12) {
                    MiniaturaProducto(foto: producto.foto, categoria: producto.categoria, tamano: 128, nombre: producto.nombre)
                        .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
                    Text(producto.nombre)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    Label(producto.categoria, systemImage: Categoria.icono(de: producto.categoria))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)

            Section("Inventario") {
                LabeledContent("Stock") { EtiquetaStock(stock: producto.stock) }
                LabeledContent("Costo promedio (sin IGV)", value: producto.costoPromedio.soles)
                LabeledContent("Valor del inventario", value: producto.valorInventario.soles)
            }

            Section("Compras aprobadas") {
                if historial.isEmpty {
                    Text("Aún no hay compras de este producto.")
                        .foregroundStyle(.secondary)
                }
                ForEach(historial) { compra in
                    NavigationLink {
                        CompraDetalleView(compra: compra)
                    } label: {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Text(compra.codigo)
                                .font(.subheadline.weight(.semibold).monospaced())
                            Spacer()
                            Text(compra.fecha.corta)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text("\(compra.cantidad) u. × \(compra.costoUnitario.soles) · \(compra.proveedor?.nombre ?? "—")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    }
                }
            }
        }
        .navigationTitle("Producto")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if sesion.usuario?.esSupervisor == true {
                Button("Editar") { editar = true }
            }
        }
        .sheet(isPresented: $editar) { ProductoFormView(producto: producto) }
    }
}
