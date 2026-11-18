import SwiftUI
import SwiftData

/// B7 · Aprobar compras desde S/ 5,000 (supervisor)
struct AprobarView: View {
    @Environment(\.modelContext) private var contexto

    // Consulta con #Predicate: solo las compras pendientes, las más antiguas primero
    @Query(filter: #Predicate<Compra> { $0.estado == "Pendiente" }, sort: \Compra.fecha)
    private var pendientes: [Compra]

    @State private var porAprobar: Compra?
    @State private var porRechazar: Compra?
    @State private var aviso: String?
    @State private var error: String?

    private var importe: Double { pendientes.reduce(0) { $0 + $1.total } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    TarjetaDestacada(titulo: "Por aprobar",
                                     valor: importe.soles,
                                     detalle: pendientes.count == 1 ? "1 compra esperando tu revisión"
                                                                    : "\(pendientes.count) compras esperando tu revisión",
                                     icono: "checkmark.seal.fill")

                    if let aviso {
                        Label(aviso, systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    if pendientes.isEmpty {
                        ContentUnavailableView("Todo al día", systemImage: "checkmark.seal",
                                               description: Text("No hay compras pendientes de aprobación."))
                            .padding(.top, 40)
                    }

                    ForEach(pendientes) { compra in
                        TarjetaAprobacion(compra: compra,
                                          aprobar: { porAprobar = compra },
                                          rechazar: { porRechazar = compra })
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Aprobar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { AvatarMenu() }      // ① Avatar
            }
            // ④ Aprobar con confirmación
            .confirmationDialog("¿Aprobar esta compra?",
                                isPresented: Binding(get: { porAprobar != nil }, set: { if !$0 { porAprobar = nil } }),
                                titleVisibility: .visible,
                                presenting: porAprobar) { compra in
                Button("Aprobar \(compra.codigo) · \(compra.total.soles)") { aprobar(compra) }
                Button("Cancelar", role: .cancel) { }
            } message: { _ in
                Text("Se actualizarán el stock y el costo promedio, y pasará a cuentas por pagar si es al crédito.")
            }
            // ④ Rechazar pide motivo
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
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func rechazar(_ compra: Compra, motivo: String) {
        do {
            let codigo = compra.codigo
            try ReglasCompra.rechazar(compra, motivo: motivo, en: contexto)
            mostrarAviso("\(codigo) rechazada")
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func mostrarAviso(_ texto: String) {
        withAnimation { aviso = texto }
        Task {
            try? await Task.sleep(for: .seconds(2.5))
            withAnimation { aviso = nil }
        }
    }
}

/// ② Tarjeta de la compra pendiente con quién la solicitó y ③ vista previa del efecto
struct TarjetaAprobacion: View {
    let compra: Compra
    let aprobar: () -> Void
    let rechazar: () -> Void

    private var stockAntes: Int { compra.producto?.stock ?? 0 }
    private var costoAntes: Double { compra.producto?.costoPromedio ?? 0 }
    private var stockDespues: Int { stockAntes + compra.cantidad }
    private var costoDespues: Double {
        ReglasCompra.nuevoCostoPromedio(stock: stockAntes, costoPromedio: costoAntes,
                                        cantidad: compra.cantidad, costoUnitario: compra.costoUnitario)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Quién la solicitó
            HStack(spacing: 10) {
                Text(compra.comprador?.iniciales ?? "?")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.teal))
                VStack(alignment: .leading, spacing: 1) {
                    Text("Solicitada por \(compra.comprador?.nombre ?? "—")")
                        .font(.subheadline.weight(.semibold))
                    Text("\(compra.codigo) · \(compra.fecha.corta)")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                Spacer()
                InsigniaEstado(compra: compra)
            }

            Divider()

            // Producto y monto
            HStack(spacing: 12) {
                MiniaturaProducto(foto: compra.producto?.foto, categoria: compra.producto?.categoria ?? "", tamano: 50)
                VStack(alignment: .leading, spacing: 2) {
                    Text(compra.producto?.nombre ?? "Producto").font(.subheadline.weight(.semibold))
                    Text(compra.proveedor?.nombre ?? "Proveedor").font(.caption).foregroundStyle(.secondary)
                    Text("\(compra.cantidad) u. × \(compra.costoUnitario.soles) · \(compra.alCredito ? "Crédito 30 días" : "Contado")")
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(compra.total.soles).font(.headline).monospacedDigit()
                    Text("IGV \(compra.igv.soles)").font(.caption2).foregroundStyle(.secondary)
                }
            }

            // Vista previa: antes → después
            VStack(spacing: 8) {
                FilaAntesDespues(titulo: "Stock", antes: "\(stockAntes) u.", despues: "\(stockDespues) u.")
                FilaAntesDespues(titulo: "Costo promedio", antes: costoAntes.soles, despues: costoDespues.soles)
            }
            .padding(12)
            .background(Color.indigo.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))

            // Botones
            HStack(spacing: 10) {
                Button(role: .destructive, action: rechazar) {
                    Label("Rechazar", systemImage: "xmark")
                        .frame(maxWidth: .infinity).padding(.vertical, 4)
                }
                .buttonStyle(.bordered)
                .tint(.red)

                Button(action: aprobar) {
                    Label("Aprobar", systemImage: "checkmark")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity).padding(.vertical, 4)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct FilaAntesDespues: View {
    let titulo: String
    let antes: String
    let despues: String

    var body: some View {
        HStack {
            Text(titulo).font(.caption).foregroundStyle(.secondary)
            Spacer()
            Text(antes).font(.caption.monospacedDigit()).foregroundStyle(.secondary)
            Image(systemName: "arrow.right").font(.caption2).foregroundStyle(.indigo)
            Text(despues).font(.caption.weight(.semibold).monospacedDigit()).foregroundStyle(.indigo)
        }
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
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
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
