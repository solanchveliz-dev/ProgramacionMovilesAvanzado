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
                    // Dos estados: si fue aceptada (aprobación) y si ya se pagó (pago)
                    HStack(spacing: 8) {
                        InsigniaTexto(texto: compra.estado,
                                      color: compra.estadoCompra == .aprobada ? .green
                                           : (compra.estadoCompra == .pendiente ? .orange : .red))
                        if compra.estadoCompra == .aprobada {
                            if compra.pagada {
                                InsigniaTexto(texto: "Pagada", color: .green)
                            } else if compra.estaVencida {
                                InsigniaTexto(texto: "VENCIDA", color: .red)
                            } else {
                                InsigniaTexto(texto: "Por pagar", color: .blue)
                            }
                        }
                    }
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

            // Seguimiento: registro → aprobación → pago
            Section("Seguimiento") {
                SeguimientoCompra(compra: compra)
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

            Section {
                LabeledContent("Forma", value: compra.alCredito ? "Crédito 30 días" : "Contado")
                if compra.alCredito {
                    LabeledContent("Vence", value: compra.vence.corta)
                }
                LabeledContent("Pagada", value: compra.pagada ? "Sí" : "No")
                if let fechaPago = compra.fechaPago {
                    LabeledContent("Fecha de pago", value: fechaPago.corta)
                }
            } header: {
                Text("Pago")
            } footer: {
                if compra.esPorPagar {
                    Text("La compra ya fue aprobada y el stock se actualizó. Falta que el supervisor la pague antes del \(compra.vence.corta).")
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

/// Insignia simple de texto blanco sobre color
struct InsigniaTexto: View {
    let texto: String
    let color: Color

    var body: some View {
        Text(texto)
            .font(.caption.weight(.bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color, in: Capsule())
            .foregroundStyle(.white)
    }
}

/// Línea de tiempo de la compra: Registrada → Aprobación → Pago
struct SeguimientoCompra: View {
    let compra: Compra

    private struct Paso: Identifiable {
        let id = UUID()
        let titulo: String
        let detalle: String
        let icono: String
        let color: Color
        let hecho: Bool
    }

    private var pasos: [Paso] {
        var lista: [Paso] = []
        // 1. Registro
        lista.append(Paso(titulo: "Registrada",
                          detalle: "\(compra.fecha.corta) · por \(compra.comprador?.nombre ?? "—")",
                          icono: "doc.text.fill", color: .indigo, hecho: true))
        // 2. Aprobación
        switch compra.estadoCompra {
        case .pendiente:
            lista.append(Paso(titulo: "Esperando aprobación",
                              detalle: "Total desde S/ 5,000: la revisa el supervisor",
                              icono: "hourglass", color: .orange, hecho: false))
        case .rechazada:
            lista.append(Paso(titulo: "Rechazada",
                              detalle: compra.motivoRechazo ?? "Sin motivo",
                              icono: "xmark", color: .red, hecho: true))
        case .aprobada:
            let automatica = compra.total < ReglasCompra.limiteAprobacion
            lista.append(Paso(titulo: automatica ? "Aprobada automáticamente" : "Aprobada por el supervisor",
                              detalle: "Stock +\(compra.cantidad) u. y costo promedio actualizado",
                              icono: "checkmark", color: .green, hecho: true))
        }
        // 3. Pago (solo si fue aprobada)
        if compra.estadoCompra == .aprobada {
            if compra.pagada {
                lista.append(Paso(titulo: compra.alCredito ? "Pagada" : "Pagada al contado",
                                  detalle: compra.alCredito ? "El \(compra.fechaPago?.corta ?? "—")" : "En el momento de la compra",
                                  icono: "banknote.fill", color: .green, hecho: true))
            } else if compra.estaVencida {
                lista.append(Paso(titulo: "Pago vencido",
                                  detalle: "Venció el \(compra.vence.corta)",
                                  icono: "exclamationmark.triangle.fill", color: .red, hecho: false))
            } else {
                lista.append(Paso(titulo: "Por pagar",
                                  detalle: "Vence el \(compra.vence.corta)",
                                  icono: "creditcard.fill", color: .blue, hecho: false))
            }
        }
        return lista
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(pasos.enumerated()), id: \.element.id) { indice, paso in
                HStack(alignment: .top, spacing: 12) {
                    VStack(spacing: 0) {
                        Image(systemName: paso.icono)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(paso.hecho ? .white : paso.color)
                            .frame(width: 28, height: 28)
                            .background(paso.hecho ? paso.color : paso.color.opacity(0.15), in: Circle())
                        if indice < pasos.count - 1 {
                            Rectangle()
                                .fill(Color(.separator))
                                .frame(width: 2, height: 26)
                        }
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(paso.titulo).font(.subheadline.weight(.semibold))
                        Text(paso.detalle).font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
