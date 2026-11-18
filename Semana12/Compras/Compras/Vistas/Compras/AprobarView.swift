import SwiftUI
import SwiftData

/// B7 · Aprobar compras desde S/ 5,000 (fiel a la maqueta)
struct AprobarView: View {
    @Environment(\.modelContext) private var contexto

    // #Predicate: solo las pendientes, las más antiguas primero
    @Query(filter: #Predicate<Compra> { $0.estado == "Pendiente" }, sort: \Compra.fecha)
    private var pendientes: [Compra]

    @State private var porAprobar: Compra?
    @State private var porRechazar: Compra?
    @State private var aviso: String?
    @State private var error: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    if let aviso {
                        Label(aviso, systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                    }

                    if pendientes.isEmpty {
                        ContentUnavailableView("Todo al día", systemImage: "checkmark.seal",
                                               description: Text("No hay compras de S/ 5,000 o más esperando aprobación."))
                            .padding(.top, 60)
                    }

                    ForEach(pendientes) { compra in
                        TarjetaAprobacion(compra: compra,                // ②
                                          aprobar: { porAprobar = compra },
                                          rechazar: { porRechazar = compra })
                    }

                    if !pendientes.isEmpty {
                        Text("Al rechazar se pide un motivo, que el comprador verá en \"Mis compras\".")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Aprobar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { AvatarMenu() }      // ①
            }
            .confirmationDialog("¿Aprobar esta compra?",
                                isPresented: Binding(get: { porAprobar != nil }, set: { if !$0 { porAprobar = nil } }),
                                titleVisibility: .visible,
                                presenting: porAprobar) { compra in
                Button("Aprobar \(compra.codigo) · \(compra.total.soles)") { aprobar(compra) }
                Button("Cancelar", role: .cancel) { }
            } message: { _ in
                Text("Se actualizarán el stock y el costo promedio.")
            }
            .sheet(item: $porRechazar) { compra in
                RechazoView(compra: compra) { motivo in rechazar(compra, motivo: motivo) }
            }
            .alert("No se pudo completar",
                   isPresented: Binding(get: { error != nil }, set: { if !$0 { error = nil } })) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text(error ?? "")
            }
            .sensoryFeedback(.success, trigger: aviso)
        }
    }

    private func aprobar(_ compra: Compra) {
        do {
            let codigo = compra.codigo
            try ReglasCompra.aprobar(compra, en: contexto)
            mostrarAviso("\(codigo) aprobada")
        } catch { self.error = error.localizedDescription }
    }

    private func rechazar(_ compra: Compra, motivo: String) {
        do {
            let codigo = compra.codigo
            try ReglasCompra.rechazar(compra, motivo: motivo, en: contexto)
            mostrarAviso("\(codigo) rechazada")
        } catch { self.error = error.localizedDescription }
    }

    private func mostrarAviso(_ texto: String) {
        withAnimation { aviso = texto }
        Task {
            try? await Task.sleep(for: .seconds(2.5))
            withAnimation { aviso = nil }
        }
    }
}

/// ② Tarjeta de la compra pendiente con quién la solicitó · ③ vista previa · ④ botones
struct TarjetaAprobacion: View {
    let compra: Compra
    let aprobar: () -> Void
    let rechazar: () -> Void

    private var stockAntes: Int { compra.producto?.stock ?? 0 }
    private var costoAntes: Double { compra.producto?.costoPromedio ?? 0 }
    private var costoDespues: Double {
        ReglasCompra.nuevoCostoPromedio(stock: stockAntes, costoPromedio: costoAntes,
                                        cantidad: compra.cantidad, costoUnitario: compra.costoUnitario)
    }
    private func ddMM(_ fecha: Date) -> String { fecha.formatted(.dateTime.day(.twoDigits).month(.twoDigits)) }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(compra.proveedor?.nombre ?? "—") · \(compra.producto?.nombre ?? "—")")
                        .font(.subheadline.weight(.bold))
                    Text("Solicitó: \(compra.comprador?.nombre ?? "—") · \(ddMM(compra.fecha))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("Pendiente")
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(Color.orange, in: Capsule())
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("\(compra.cantidad) u. × \(compra.costoUnitario.soles) = \(compra.subtotal.soles)")
                Text("IGV 18 % \(compra.igv.soles) · ") + Text("Total \(compra.total.soles)").bold()
                Text(compra.alCredito ? "Crédito 30 días · vence \(ddMM(compra.vence))" : "Contado")
            }
            .font(.footnote)
            .monospacedDigit()

            // ③ Vista previa del efecto
            VStack(alignment: .leading, spacing: 3) {
                Text("Si apruebas: ") + Text("stock \(stockAntes) → \(stockAntes + compra.cantidad)").bold()
                Text("Costo promedio ") + Text("\(costoAntes.soles) → \(costoDespues.soles)").bold()
            }
            .font(.footnote)
            .monospacedDigit()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))

            // ④ Rechazar (pide motivo) o Aprobar
            HStack(spacing: 10) {
                Button(action: rechazar) {
                    Text("Rechazar").fontWeight(.semibold)
                        .frame(maxWidth: .infinity).padding(.vertical, 6)
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button(action: aprobar) {
                    Text("Aprobar").fontWeight(.semibold)
                        .frame(maxWidth: .infinity).padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

/// Hoja para rechazar: el motivo es obligatorio
struct RechazoView: View {
    @Environment(\.dismiss) private var dismiss
    let compra: Compra
    let confirmar: (String) -> Void

    @State private var motivo = ""
    private let sugerencias = ["Precio por encima del mercado", "Excede el presupuesto del mes",
                               "Proveedor no homologado", "Stock suficiente por ahora"]
    private var motivoVacio: Bool { motivo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Compra", value: compra.codigo)
                    LabeledContent("Total", value: compra.total.soles)
                }
                Section {
                    TextField("Escribe el motivo", text: $motivo, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("Motivo (obligatorio)")
                } footer: {
                    Text("El comprador verá este motivo en Mis compras.")
                }
                Section("Sugerencias") {
                    ForEach(sugerencias, id: \.self) { texto in
                        Button(texto) { motivo = texto }
                    }
                }
            }
            .navigationTitle("Rechazar compra")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Rechazar", role: .destructive) {
                        confirmar(motivo)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .tint(.red)
                    .disabled(motivoVacio)          // Sin motivo no se puede (caso 7)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
