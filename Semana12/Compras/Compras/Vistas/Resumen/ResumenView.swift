import SwiftUI
import SwiftData
import Charts

/// B9 · Resumen del supervisor
struct ResumenView: View {
    @Environment(Sesion.self) private var sesion
    @Query private var productos: [Producto]
    @Query private var proveedores: [Proveedor]
    @Query private var compras: [Compra]

    // MARK: - Cálculos
    private var inicioMes: Date { Calendar.current.dateInterval(of: .month, for: .now)?.start ?? .now }
    private var aprobadas: [Compra] { compras.filter { $0.estadoCompra == .aprobada } }
    private var pendientes: [Compra] { compras.filter { $0.estadoCompra == .pendiente } }

    /// ② Valor del inventario
    private var valorInventario: Double { productos.reduce(0) { $0 + $1.valorInventario } }
    /// ③ Crédito fiscal: IGV de las compras aprobadas del mes
    private var creditoFiscalMes: Double {
        ReglasCompra.redondear(aprobadas.filter { $0.fecha >= inicioMes }.reduce(0) { $0 + $1.igv })
    }
    private var creditoFiscalTotal: Double { ReglasCompra.redondear(aprobadas.reduce(0) { $0 + $1.igv }) }
    /// Por pagar
    private var porPagar: Double { aprobadas.filter(\.esPorPagar).reduce(0) { $0 + $1.total } }
    private var vencidas: [Compra] { aprobadas.filter(\.estaVencida) }
    /// ④ Por aprobar (cantidad e importe)
    private var importePorAprobar: Double { pendientes.reduce(0) { $0 + $1.total } }

    /// ⑤ Total comprado por proveedor
    struct TotalProveedor: Identifiable {
        let nombre: String
        let total: Double
        var id: String { nombre }
    }

    private var porProveedor: [TotalProveedor] {
        proveedores
            .map { TotalProveedor(nombre: $0.nombre, total: $0.totalComprado) }
            .filter { $0.total > 0 }
            .sorted { $0.total > $1.total }
    }

    private var stockBajo: [Producto] { productos.filter { $0.stock <= 5 }.sorted { $0.stock < $1.stock } }

    private var saludo: String {
        let hora = Calendar.current.component(.hour, from: .now)
        return hora < 12 ? "Buenos días" : (hora < 19 ? "Buenas tardes" : "Buenas noches")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Saludo
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(saludo), \(sesion.usuario?.nombre.split(separator: " ").first.map(String.init) ?? "")")
                            .font(.title3.weight(.semibold))
                        Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // ② Valor del inventario
                    TarjetaDestacada(titulo: "Valor del inventario",
                                     valor: valorInventario.soles,
                                     detalle: "\(productos.count) productos · \(stockBajo.count) con stock bajo",
                                     icono: "shippingbox.fill")

                    // Indicadores
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        TarjetaIndicador(titulo: "Crédito fiscal (IGV)", valor: creditoFiscalMes.soles,
                                         detalle: "Este mes · total \(creditoFiscalTotal.soles)",
                                         icono: "percent", color: .teal)
                        TarjetaIndicador(titulo: "Por pagar", valor: porPagar.soles,
                                         detalle: vencidas.isEmpty ? "Ninguna vencida" : "\(vencidas.count) vencida(s)",
                                         icono: "creditcard.fill", color: vencidas.isEmpty ? .blue : .red)
                        TarjetaIndicador(titulo: "Por aprobar", valor: importePorAprobar.soles,
                                         detalle: pendientes.count == 1 ? "1 compra" : "\(pendientes.count) compras",
                                         icono: "checkmark.seal.fill", color: .orange)
                        TarjetaIndicador(titulo: "Compras aprobadas", valor: "\(aprobadas.count)",
                                         detalle: "\(proveedores.count) proveedores",
                                         icono: "cart.fill", color: .indigo)
                    }

                    // ⑤ Total comprado por proveedor con barras
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Total comprado por proveedor")
                            .font(.headline)
                        if porProveedor.isEmpty {
                            Text("Aún no hay compras aprobadas.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 80)
                        } else {
                            Chart(porProveedor) { item in
                                BarMark(x: .value("Total", item.total),
                                        y: .value("Proveedor", item.nombre))
                                    .foregroundStyle(Color.indigo.gradient)
                                    .cornerRadius(6)
                                    .annotation(position: .trailing) {
                                        Text(item.total.soles)
                                            .font(.caption2.weight(.semibold))
                                            .foregroundStyle(.secondary)
                                    }
                            }
                            .chartXAxis(.hidden)
                            .chartYAxis {
                                AxisMarks { _ in AxisValueLabel().font(.caption) }
                            }
                            .frame(height: CGFloat(max(porProveedor.count, 1)) * 44 + 10)
                        }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))

                    // Stock bajo
                    if !stockBajo.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Productos con stock bajo", systemImage: "exclamationmark.triangle.fill")
                                .font(.headline)
                                .foregroundStyle(.red)
                            ForEach(stockBajo) { p in
                                HStack(spacing: 10) {
                                    MiniaturaProducto(foto: p.foto, categoria: p.categoria, tamano: 36)
                                    Text(p.nombre).font(.subheadline).lineLimit(1)
                                    Spacer()
                                    EtiquetaStock(stock: p.stock)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Resumen")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { AvatarMenu() }      // ① Avatar
            }
        }
    }
}

/// Tarjeta de indicador con ícono de color
struct TarjetaIndicador: View {
    let titulo: String
    let valor: String
    let detalle: String
    let icono: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icono)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.14), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
            Text(valor)
                .font(.headline)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            VStack(alignment: .leading, spacing: 1) {
                Text(titulo).font(.caption.weight(.semibold))
                Text(detalle).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

#Preview {
    ResumenView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
