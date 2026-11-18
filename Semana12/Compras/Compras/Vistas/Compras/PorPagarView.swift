import SwiftUI
import SwiftData

/// B8 · Por pagar (fiel a la maqueta)
struct PorPagarView: View {
    @Environment(\.modelContext) private var contexto

    // #Predicate: solo compras aprobadas al crédito (las únicas que generan deuda)
    @Query(filter: #Predicate<Compra> { $0.estado == "Aprobada" && $0.alCredito == true },
           sort: \Compra.vence)
    private var creditos: [Compra]

    enum Filtro: String, CaseIterable, Identifiable {
        case pendientes = "Pendientes", vencidas = "Vencidas", pagadas = "Pagadas"
        var id: String { rawValue }
    }

    @State private var filtro: Filtro = .pendientes
    @State private var busqueda = ""
    @State private var porPagar: Compra?

    /// Pendientes de pago = no pagadas (las vencidas también son pendientes, solo que ya pasó su fecha)
    private var noPagadas: [Compra] { creditos.filter { !$0.pagada } }
    private var vencidas: [Compra] { noPagadas.filter(\.estaVencida) }
    private var pagadas: [Compra] {
        creditos.filter(\.pagada).sorted { ($0.fechaPago ?? .distantPast) > ($1.fechaPago ?? .distantPast) }
    }

    /// ⑤ Total por pagar: aprobadas al crédito y no pagadas
    private var totalPorPagar: Double { noPagadas.reduce(0) { $0 + $1.total } }

    private var visibles: [Compra] {
        let base: [Compra]
        switch filtro {
        case .pendientes: base = noPagadas
        case .vencidas: base = vencidas
        case .pagadas: base = pagadas
        }
        guard !busqueda.isEmpty else { return base }
        return base.filter { $0.proveedor?.nombre.localizedCaseInsensitiveContains(busqueda) ?? false }
    }

    var body: some View {
        NavigationStack {
            List {
                // ① Segmented Pendientes / Vencidas / Pagadas
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
                        ContentUnavailableView(filtro == .pagadas ? "Sin pagos todavía" : "Nada por pagar aquí",
                                               systemImage: filtro == .pagadas ? "banknote" : "checkmark.circle",
                                               description: Text(filtro == .vencidas ? "Ninguna cuenta está vencida."
                                                                 : "No hay compras en esta lista."))
                            .listRowBackground(Color.clear)
                    }
                    ForEach(visibles) { compra in
                        NavigationLink {
                            CompraDetalleView(compra: compra)
                        } label: {
                            FilaPorPagar(compra: compra)              // ② ③
                        }
                        // ④ Deslizar Pagar (esta pestaña solo existe para el supervisor)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            if !compra.pagada {
                                Button { porPagar = compra } label: { Label("Pagar", systemImage: "banknote") }
                                    .tint(.green)
                            }
                        }
                    }
                }

                // ⑤ Total por pagar
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total por pagar")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(totalPorPagar.soles)
                            .font(.title2.bold())
                            .monospacedDigit()
                    }
                    .padding(.vertical, 4)
                } footer: {
                    Text("Solo cuentan compras aprobadas a crédito y no pagadas. Desliza una fila para pagar.")
                }
            }
            .listSectionSpacing(14)
            .searchable(text: $busqueda, prompt: "Buscar por proveedor")
            .navigationTitle("Por pagar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { AvatarMenu() }
            }
            .confirmationDialog("¿Registrar el pago?",
                                isPresented: Binding(get: { porPagar != nil }, set: { if !$0 { porPagar = nil } }),
                                titleVisibility: .visible,
                                presenting: porPagar) { compra in
                Button("Pagar \(compra.total.soles) a \(compra.proveedor?.nombre ?? "proveedor")") {
                    try? ReglasCompra.pagar(compra, en: contexto)
                }
                Button("Cancelar", role: .cancel) { }
            } message: { compra in
                Text("\(compra.codigo) pasará a Pagadas y el total por pagar bajará.")
            }
        }
    }
}

/// Fila como en la maqueta: iniciales del proveedor, "Producto × cantidad · vence dd/MM", total y VENCIDA
struct FilaPorPagar: View {
    let compra: Compra

    private func ddMM(_ fecha: Date) -> String { fecha.formatted(.dateTime.day(.twoDigits).month(.twoDigits)) }

    var body: some View {
        HStack(spacing: 12) {
            Iniciales(nombre: compra.proveedor?.nombre ?? "?", tamano: 42)
            VStack(alignment: .leading, spacing: 2) {
                Text(compra.proveedor?.nombre ?? "Proveedor")
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text(compra.pagada
                     ? "\(compra.producto?.nombre ?? "—") × \(compra.cantidad) · pagada \(compra.fechaPago.map(ddMM) ?? "")"
                     : "\(compra.producto?.nombre ?? "—") × \(compra.cantidad) · vence \(ddMM(compra.vence))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            Spacer(minLength: 6)
            VStack(alignment: .trailing, spacing: 4) {
                Text(compra.total.soles)
                    .font(.subheadline.weight(.bold))
                    .monospacedDigit()
                if compra.estaVencida {                     // ③ Etiqueta VENCIDA
                    Text("VENCIDA")
                        .font(.caption2.weight(.heavy))
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.red, in: Capsule())
                        .foregroundStyle(.white)
                } else if compra.pagada {
                    Text("Pagada")
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(Color.green, in: Capsule())
                        .foregroundStyle(.white)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
