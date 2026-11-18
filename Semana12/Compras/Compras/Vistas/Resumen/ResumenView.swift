import SwiftUI
import SwiftData

/// B9 · Resumen del supervisor (fiel a la maqueta)
struct ResumenView: View {
    @Environment(\.modelContext) private var contexto
    @Query private var productos: [Producto]
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query private var compras: [Compra]

    @State private var confirmarDemo = false
    @State private var resultadoDemo: String?

    private var aprobadas: [Compra] { compras.filter { $0.estadoCompra == .aprobada } }
    private var pendientes: [Compra] { compras.filter { $0.estadoCompra == .pendiente } }

    /// ② Valor del inventario
    private var inventario: Double { productos.reduce(0) { $0 + $1.valorInventario } }
    /// ③ Crédito fiscal: IGV de las compras aprobadas
    private var creditoFiscal: Double { ReglasCompra.redondear(aprobadas.reduce(0) { $0 + $1.igv }) }
    /// Por pagar: aprobadas al crédito y no pagadas
    private var porPagar: Double { aprobadas.filter(\.esPorPagar).reduce(0) { $0 + $1.total } }
    /// ④ Por aprobar: cantidad e importe
    private var importePorAprobar: Double { pendientes.reduce(0) { $0 + $1.total } }

    /// ⑤ Total comprado por proveedor (mayor primero)
    private var porProveedor: [Proveedor] {
        proveedores.filter { $0.totalComprado > 0 }.sorted { $0.totalComprado > $1.totalComprado }
    }
    private var maximo: Double { porProveedor.first?.totalComprado ?? 1 }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    // ② ③ ④ Indicadores
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        TarjetaValor(titulo: "Inventario", valor: inventario.soles)
                        TarjetaValor(titulo: "Crédito fiscal", valor: creditoFiscal.soles)
                        TarjetaValor(titulo: "Por pagar", valor: porPagar.soles)
                        TarjetaValor(titulo: "Por aprobar", valor: "\(pendientes.count)",
                                     detalle: importePorAprobar.soles, colorDetalle: .orange)
                    }

                    // Ver todas las compras (el supervisor "ve todo")
                    NavigationLink {
                        TodasComprasView()
                    } label: {
                        HStack {
                            Label("Ver todas las compras", systemImage: "list.bullet.rectangle.fill")
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Text("\(compras.count)")
                                .font(.subheadline.monospacedDigit())
                                .foregroundStyle(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    // ⑤ Total comprado por proveedor con barras
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Total comprado por proveedor")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if porProveedor.isEmpty {
                            Text("Aún no hay compras aprobadas.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        ForEach(porProveedor) { proveedor in
                            VStack(alignment: .leading, spacing: 5) {
                                (Text(proveedor.nombre).bold() + Text(" · \(proveedor.totalComprado.soles)").foregroundColor(.secondary))
                                    .font(.footnote)
                                    .lineLimit(1)
                                ProgressView(value: proveedor.totalComprado, total: maximo)
                                    .tint(.green)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Resumen")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu {
                        Button { confirmarDemo = true } label: {
                            Label("Cargar datos de demostración", systemImage: "tray.and.arrow.down")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    AvatarMenu()                                              // ①
                }
            }
            .confirmationDialog("¿Cargar datos de demostración?", isPresented: $confirmarDemo, titleVisibility: .visible) {
                Button("Cargar catálogo de ejemplo") {
                    let r = DatosDemo.cargar(en: contexto)
                    resultadoDemo = "Se agregaron \(r.proveedores) proveedores y \(r.productos) productos."
                }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("Agrega 4 proveedores y 7 productos de ejemplo. No borra ni duplica lo que ya existe.")
            }
            .alert("Datos cargados",
                   isPresented: Binding(get: { resultadoDemo != nil }, set: { if !$0 { resultadoDemo = nil } })) {
                Button("Listo", role: .cancel) { }
            } message: {
                Text(resultadoDemo ?? "")
            }
        }
    }
}

#Preview {
    ResumenView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
