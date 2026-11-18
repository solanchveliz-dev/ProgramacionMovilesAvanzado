import SwiftUI
import SwiftData

/// Insignia de estado: Pendiente (naranja), Aprobada (verde), Rechazada (rojo), Vencida, Pagada
struct InsigniaEstado: View {
    let compra: Compra

    private var info: (texto: String, icono: String, color: Color) {
        if compra.estaVencida { return ("VENCIDA", "exclamationmark.triangle.fill", .red) }
        switch compra.estadoCompra {
        case .pendiente: return ("Pendiente", "clock.fill", .orange)
        case .rechazada: return ("Rechazada", "xmark.circle.fill", .red)
        case .aprobada:
            if compra.alCredito && !compra.pagada { return ("Por pagar", "creditcard.fill", .blue) }
            return ("Pagada", "checkmark.circle.fill", .green)
        }
    }

    var body: some View {
        Label(info.texto, systemImage: info.icono)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(info.color.opacity(0.14), in: Capsule())
            .foregroundStyle(info.color)
    }
}

/// Fila de una compra (se usa en Mis compras, Aprobar y Por pagar)
struct FilaCompra: View {
    let compra: Compra
    var mostrarComprador = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                MiniaturaProducto(foto: compra.producto?.foto,
                                  categoria: compra.producto?.categoria ?? "", tamano: 46)
                VStack(alignment: .leading, spacing: 3) {
                    Text(compra.producto?.nombre ?? "Producto")
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                    Text(compra.proveedor?.nombre ?? "Proveedor")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Text("\(compra.codigo) · \(compra.fecha.corta)\(mostrarComprador ? " · \(compra.comprador?.nombre ?? "—")" : "")")
                        .font(.caption2.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 6)
                VStack(alignment: .trailing, spacing: 6) {
                    Text(compra.total.soles)
                        .font(.subheadline.weight(.bold))
                        .monospacedDigit()
                    InsigniaEstado(compra: compra)
                }
            }
            // ③ Compra rechazada con su motivo
            if compra.estadoCompra == .rechazada, let motivo = compra.motivoRechazo {
                Label(motivo, systemImage: "text.bubble.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.vertical, 4)
    }
}

/// Detalle de una compra (para el comprador y el supervisor)
struct CompraDetalleView: View {
    let compra: Compra

    var body: some View {
        List {
            Section {
                VStack(spacing: 10) {
                    MiniaturaProducto(foto: compra.producto?.foto,
                                      categoria: compra.producto?.categoria ?? "", tamano: 88)
                    Text(compra.codigo).font(.title2.bold().monospaced())
                    InsigniaEstado(compra: compra)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
            }
            .listRowBackground(Color.clear)

            if compra.estadoCompra == .rechazada, let motivo = compra.motivoRechazo {
                Section("Motivo del rechazo") {
                    Text(motivo).foregroundStyle(.red)
                }
            }

            Section("Compra") {
                LabeledContent("Producto", value: compra.producto?.nombre ?? "—")
                LabeledContent("Proveedor", value: compra.proveedor?.nombre ?? "—")
                LabeledContent("Registrada por", value: compra.comprador?.nombre ?? "—")
                LabeledContent("Fecha", value: compra.fecha.corta)
            }

            Section("Importe") {
                LabeledContent("Cantidad", value: "\(compra.cantidad) u.")
                LabeledContent("Costo unitario", value: compra.costoUnitario.soles)
                LabeledContent("Subtotal", value: compra.subtotal.soles)
                LabeledContent("IGV 18 % (crédito fiscal)", value: compra.igv.soles)
                LabeledContent {
                    Text(compra.total.soles).font(.headline).monospacedDigit()
                } label: {
                    Text("Total").font(.headline)
                }
            }

            Section("Pago") {
                LabeledContent("Forma", value: compra.alCredito ? "Crédito 30 días" : "Contado")
                if compra.alCredito {
                    LabeledContent("Vence", value: compra.vence.corta)
                }
                LabeledContent("Pagada", value: compra.pagada ? "Sí" : "No")
                if let fechaPago = compra.fechaPago {
                    LabeledContent("Fecha de pago", value: fechaPago.corta)
                }
            }
        }
        .navigationTitle("Detalle de compra")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Tarjeta pequeña de indicador (número + etiqueta)
struct IndicadorMini: View {
    let titulo: String
    let valor: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(valor)
                .font(.title2.bold())
                .monospacedDigit()
                .foregroundStyle(color)
            Text(titulo)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
