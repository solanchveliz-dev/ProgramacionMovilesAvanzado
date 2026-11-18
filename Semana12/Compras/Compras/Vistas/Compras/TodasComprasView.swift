import SwiftUI
import SwiftData

/// Supervisor · Todas las compras ("ver todo", según la guía)
struct TodasComprasView: View {
    @Query(sort: \Compra.fecha, order: .reverse) private var compras: [Compra]

    enum Filtro: String, CaseIterable, Identifiable {
        case todas = "Todas", pendientes = "Pendientes", aprobadas = "Aprobadas", rechazadas = "Rechazadas"
        var id: String { rawValue }
    }

    @State private var filtro: Filtro = .todas
    @State private var busqueda = ""

    private var visibles: [Compra] {
        compras.filter { c in
            let pasa: Bool
            switch filtro {
            case .todas: pasa = true
            case .pendientes: pasa = c.estadoCompra == .pendiente
            case .aprobadas: pasa = c.estadoCompra == .aprobada
            case .rechazadas: pasa = c.estadoCompra == .rechazada
            }
            let busca = busqueda.isEmpty
                || (c.proveedor?.nombre.localizedCaseInsensitiveContains(busqueda) ?? false)
                || (c.comprador?.nombre.localizedCaseInsensitiveContains(busqueda) ?? false)
                || c.codigo.localizedCaseInsensitiveContains(busqueda)
            return pasa && busca
        }
    }

    private var total: Double { visibles.filter { $0.estadoCompra == .aprobada }.reduce(0) { $0 + $1.total } }

    var body: some View {
        List {
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
                    ContentUnavailableView("Sin compras", systemImage: "cart",
                                           description: Text("No hay compras con este filtro."))
                        .listRowBackground(Color.clear)
                }
                ForEach(visibles) { compra in
                    NavigationLink {
                        CompraDetalleView(compra: compra)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            FilaMiCompra(compra: compra)
                            Label("\(compra.codigo) · \(compra.comprador?.nombre ?? "—")", systemImage: "person.fill")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text(visibles.count == 1 ? "1 compra" : "\(visibles.count) compras")
            } footer: {
                if !visibles.isEmpty {
                    Text("Total aprobado en esta lista: \(total.soles)")
                }
            }
        }
        .listSectionSpacing(12)
        .searchable(text: $busqueda, prompt: "Proveedor, comprador o código")
        .navigationTitle("Todas las compras")
        .navigationBarTitleDisplayMode(.inline)
    }
}
