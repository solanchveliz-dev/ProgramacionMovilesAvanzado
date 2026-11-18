import SwiftUI
import SwiftData

/// B6 · Mis compras (comprador): solo ve las suyas
struct MisComprasView: View {
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Compra.fecha, order: .reverse) private var todas: [Compra]

    enum Filtro: String, CaseIterable, Identifiable {
        case todas = "Todas", pendientes = "Pendientes", rechazadas = "Rechazadas"
        var id: String { rawValue }
    }

    @State private var filtro: Filtro = .todas
    @State private var busqueda = ""

    /// ④ El comprador solo ve las suyas (filtro por la relación compra.comprador)
    private var mias: [Compra] {
        guard let usuario = sesion.usuario else { return [] }
        return todas.filter { $0.comprador?.persistentModelID == usuario.persistentModelID }
    }

    private var visibles: [Compra] {
        mias.filter { c in
            let pasaFiltro: Bool
            switch filtro {
            case .todas: pasaFiltro = true
            case .pendientes: pasaFiltro = c.estadoCompra == .pendiente
            case .rechazadas: pasaFiltro = c.estadoCompra == .rechazada
            }
            let pasaBusqueda = busqueda.isEmpty
                || (c.proveedor?.nombre.localizedCaseInsensitiveContains(busqueda) ?? false)
                || (c.producto?.nombre.localizedCaseInsensitiveContains(busqueda) ?? false)
            return pasaFiltro && pasaBusqueda
        }
    }

    private var totalMes: Double {
        let inicioMes = Calendar.current.dateInterval(of: .month, for: .now)?.start ?? .now
        return mias.filter { $0.estadoCompra == .aprobada && $0.fecha >= inicioMes }.reduce(0) { $0 + $1.total }
    }

    var body: some View {
        NavigationStack {
            List {
                // Indicadores propios
                Section {
                    HStack(spacing: 10) {
                        IndicadorMini(titulo: "Pendientes",
                                      valor: "\(mias.filter { $0.estadoCompra == .pendiente }.count)", color: .orange)
                        IndicadorMini(titulo: "Aprobadas",
                                      valor: "\(mias.filter { $0.estadoCompra == .aprobada }.count)", color: .green)
                        IndicadorMini(titulo: "Rechazadas",
                                      valor: "\(mias.filter { $0.estadoCompra == .rechazada }.count)", color: .red)
                    }
                    LabeledContent("Comprado este mes", value: totalMes.soles)
                        .font(.subheadline.weight(.medium))
                        .padding(.horizontal, 4)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // ① Segmented Todas / Pendientes / Rechazadas
                Section {
                    Picker("Filtro", selection: $filtro) {
                        ForEach(Filtro.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                Section {
                    if visibles.isEmpty {
                        ContentUnavailableView(mias.isEmpty ? "Aún no tienes compras" : "Sin resultados",
                                               systemImage: "cart",
                                               description: Text(mias.isEmpty ? "Registra tu primera compra en la pestaña Compra."
                                                                              : "Prueba con otro filtro o búsqueda."))
                            .listRowBackground(Color.clear)
                    }
                    ForEach(visibles) { compra in
                        NavigationLink {
                            CompraDetalleView(compra: compra)
                        } label: {
                            FilaCompra(compra: compra)
                        }
                    }
                    // Sin .onDelete ni acción de Pagar: el comprador solo consulta (caso 9)
                } header: {
                    Text(visibles.count == 1 ? "1 compra" : "\(visibles.count) compras")
                }
            }
            .listSectionSpacing(14)
            .searchable(text: $busqueda, prompt: "Buscar por proveedor o producto")
            .navigationTitle("Mis compras")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { AvatarMenu() }
            }
        }
    }
}
