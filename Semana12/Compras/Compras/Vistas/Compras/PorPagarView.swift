import SwiftUI
import SwiftData

/// B8 · Cuentas por pagar (supervisor)
struct PorPagarView: View {
    @Environment(\.modelContext) private var contexto

    // #Predicate: solo compras aprobadas y al crédito (las únicas que generan deuda)
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
    @State private var aviso: String?

    private var noPagadas: [Compra] { creditos.filter { !$0.pagada } }
    private var vencidas: [Compra] { noPagadas.filter(\.estaVencida) }

    /// ⑤ Total por pagar (pendientes + vencidas)
    private var totalPorPagar: Double { noPagadas.reduce(0) { $0 + $1.total } }
    private var totalVencido: Double { vencidas.reduce(0) { $0 + $1.total } }

    private var visibles: [Compra] {
        let base: [Compra]
        switch filtro {
        case .pendientes: base = noPagadas.filter { !$0.estaVencida }
        case .vencidas: base = vencidas
        case .pagadas: base = creditos.filter(\.pagada).sorted { ($0.fechaPago ?? .distantPast) > ($1.fechaPago ?? .distantPast) }
        }
        guard !busqueda.isEmpty else { return base }
        return base.filter { $0.proveedor?.nombre.localizedCaseInsensitiveContains(busqueda) ?? false }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TarjetaDestacada(titulo: "Total por pagar",
                                     valor: totalPorPagar.soles,
                                     detalle: vencidas.isEmpty
                                        ? "\(noPagadas.count) cuenta(s) pendiente(s), ninguna vencida"
                                        : "\(vencidas.count) vencida(s) por \(totalVencido.soles)",
                                     icono: "creditcard.fill")
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // ① Segmented Pendientes / Vencidas / Pagadas
                Section {
                    Picker("Filtro", selection: $filtro) {
                        ForEach(Filtro.allCases) { f in
                            Text(f == .vencidas && !vencidas.isEmpty ? "Vencidas (\(vencidas.count))" : f.rawValue).tag(f)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                Section {
                    if visibles.isEmpty {
                        ContentUnavailableView(mensajeVacio.titulo, systemImage: mensajeVacio.icono,
                                               description: Text(mensajeVacio.detalle))
                            .listRowBackground(Color.clear)
                    }
                    ForEach(visibles) { compra in
                        NavigationLink {
                            CompraDetalleView(compra: compra)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                FilaCompra(compra: compra, mostrarComprador: true)
                                TextoVencimiento(compra: compra)
                            }
                        }
                        // ④ Deslizar Pagar (esta pestaña solo existe para el supervisor)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            if !compra.pagada {
                                Button { porPagar = compra } label: {
                                    Label("Pagar", systemImage: "banknote")
                                }
                                .tint(.green)
                            }
                        }
                    }
                } header: {
                    Text(visibles.count == 1 ? "1 cuenta" : "\(visibles.count) cuentas")
                } footer: {
                    if filtro != .pagadas && !visibles.isEmpty {
                        Text("Desliza una fila a la izquierda para registrar el pago.")
                    }
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
                Button("Pagar \(compra.total.soles) a \(compra.proveedor?.nombre ?? "proveedor")") { pagar(compra) }
                Button("Cancelar", role: .cancel) { }
            } message: { compra in
                Text("\(compra.codigo) pasará a Pagadas y el total por pagar bajará.")
            }
            .sensoryFeedback(.success, trigger: aviso)
            .overlay(alignment: .bottom) {
                if let aviso {
                    Label(aviso, systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 16).padding(.vertical, 10)
                        .background(.regularMaterial, in: Capsule())
                        .foregroundStyle(.green)
                        .padding(.bottom, 12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }

    private var mensajeVacio: (titulo: String, icono: String, detalle: String) {
        switch filtro {
        case .pendientes: return ("Sin cuentas pendientes", "checkmark.circle", "No hay compras al crédito por pagar.")
        case .vencidas: return ("Nada vencido", "calendar.badge.checkmark", "Todas las cuentas están dentro de plazo.")
        case .pagadas: return ("Sin pagos todavía", "banknote", "Aquí aparecerán las compras al crédito ya pagadas.")
        }
    }

    private func pagar(_ compra: Compra) {
        let codigo = compra.codigo
        do {
            try ReglasCompra.pagar(compra, en: contexto)
            withAnimation { aviso = "\(codigo) pagada" }
            Task {
                try? await Task.sleep(for: .seconds(2.5))
                withAnimation { aviso = nil }
            }
        } catch { }
    }
}

/// Texto del vencimiento: "Vence en 12 días", "Venció hace 3 días" o "Pagada el ..."
struct TextoVencimiento: View {
    let compra: Compra

    private var dias: Int {
        let hoy = Calendar.current.startOfDay(for: .now)
        let vence = Calendar.current.startOfDay(for: compra.vence)
        return Calendar.current.dateComponents([.day], from: hoy, to: vence).day ?? 0
    }

    var body: some View {
        Group {
            if compra.pagada {
                Label("Pagada el \(compra.fechaPago?.corta ?? "—")", systemImage: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            } else if dias < 0 {
                Label("Venció el \(compra.vence.corta) · hace \(-dias) día(s)", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(.red)
            } else if dias == 0 {
                Label("Vence hoy", systemImage: "calendar.badge.exclamationmark")
                    .foregroundStyle(.orange)
            } else {
                Label("Vence el \(compra.vence.corta) · en \(dias) día(s)", systemImage: "calendar")
                    .foregroundStyle(dias <= 5 ? Color.orange : Color.secondary)
            }
        }
        .font(.caption.weight(.medium))
    }
}
