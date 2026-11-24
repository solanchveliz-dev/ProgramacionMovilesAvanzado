import SwiftUI
import SwiftData

/// B5 · Nueva compra (comprador)
struct NuevaCompraView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]
    @Query(sort: \Producto.nombre) private var productos: [Producto]

    @State private var proveedor: Proveedor?
    @State private var producto: Producto?
    @State private var cantidad = 1
    @State private var costoTexto = ""
    @State private var alCredito = false
    @State private var fecha = Date.now
    @State private var registrada: Compra?
    @State private var error: String?

    private var costo: Double? { Double(costoTexto.replacingOccurrences(of: ",", with: ".")) }

    /// ⑤ Resumen calculado en vivo con las reglas del negocio
    private var calculo: ReglasCompra.Calculo? {
        guard let costo, costo > 0, cantidad > 0 else { return nil }
        return ReglasCompra.calcular(cantidad: cantidad, costoUnitario: costo)
    }
    private var requiereAprobacion: Bool { calculo?.requiereAprobacion ?? false }
    private var formularioValido: Bool { proveedor != nil && producto != nil && calculo != nil }

    var body: some View {
        NavigationStack {
            Group {
                if proveedores.isEmpty || productos.isEmpty {
                    ContentUnavailableView("Aún no se puede comprar", systemImage: "cart.badge.questionmark",
                                           description: Text("El supervisor debe registrar al menos un proveedor y un producto."))
                } else {
                    formulario
                }
            }
            .navigationTitle("Nueva compra")
            .subtitulo("Registra una compra al proveedor")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { AvatarMenu() }      // ① Avatar de la sesión
            }
            .sheet(item: $registrada) { compra in
                CompraRegistradaView(compra: compra) { limpiar() }
            }
            .alert("No se pudo registrar",
                   isPresented: Binding(get: { error != nil }, set: { if !$0 { error = nil } })) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text(error ?? "")
            }
        }
    }

    private var formulario: some View {
        Form {
            // ② Proveedor y ③ Producto
            Section {
                Picker(selection: $proveedor) {
                    Text("Elegir").tag(Proveedor?.none)
                    ForEach(proveedores) { p in
                        Text(p.nombre).tag(Optional(p))
                    }
                } label: {
                    EtiquetaFila("Proveedor", icono: "building.2.fill", color: .blue)
                }
                .pickerStyle(.navigationLink)
                Picker(selection: $producto) {
                    Text("Elegir").tag(Producto?.none)
                    ForEach(productos) { p in
                        Text(p.nombre).tag(Optional(p))
                    }
                } label: {
                    EtiquetaFila("Producto", icono: "shippingbox.fill", color: .orange)
                }
                .pickerStyle(.navigationLink)

                // ④ Cantidad y costo en recuadros, como en la maqueta
                HStack {
                    EtiquetaFila("Cantidad", icono: "number", color: .teal)
                    Spacer()
                    TextField("0", value: $cantidad, format: .number)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .monospacedDigit()
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .frame(width: 96)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.separator)))
                }
                HStack {
                    EtiquetaFila("Costo unitario", icono: "dollarsign", color: .green)
                    Spacer()
                    TextField("0.00", text: $costoTexto)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .monospacedDigit()
                        .padding(.horizontal, 10).padding(.vertical, 6)
                        .frame(width: 110)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.separator)))
                }
                DatePicker(selection: $fecha, in: ...Date.now, displayedComponents: .date) {
                    EtiquetaFila("Fecha de la factura", icono: "calendar", color: .red)
                }
            }

            if let producto {
                Section {
                    HStack(spacing: 12) {
                        MiniaturaProducto(foto: producto.foto, categoria: producto.categoria, tamano: 44)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(producto.nombre).font(.subheadline.weight(.semibold))
                            Text("Costo prom. \(producto.costoPromedio.soles)")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        EtiquetaStock(stock: producto.stock)
                    }
                }
            }

            // ⑤ Contado o Crédito 30 días
            Section {
                // ⑤ Contado o Crédito 30 días
                Picker("Forma de pago", selection: $alCredito) {
                    Text("Contado").tag(false)
                    Text("Crédito 30 días").tag(true)
                }
                .pickerStyle(.segmented)
                if alCredito {
                    LabeledContent {
                        Text(ReglasCompra.fechaVencimiento(desde: fecha, alCredito: true).corta)
                    } label: {
                        EtiquetaFila("Vence el", icono: "clock.badge.exclamationmark", color: .purple)
                    }
                }
            }

            // Resumen calculado
            if let calculo {
                Section("Resumen") {
                    LabeledContent {
                        Text(calculo.subtotal.soles).monospacedDigit()
                    } label: {
                        EtiquetaFila("Subtotal", icono: "list.bullet.rectangle", color: .gray)
                    }
                    LabeledContent {
                        Text(calculo.igv.soles).monospacedDigit()
                    } label: {
                        EtiquetaFila("IGV 18 %", icono: "percent", color: .gray)
                    }
                    LabeledContent {
                        Text(calculo.total.soles)
                            .font(.title3.bold())
                            .monospacedDigit()
                            .foregroundStyle(.primary)
                    } label: {
                        Label {
                            Text("Total").font(.headline)
                        } icon: {
                            IconoFila(nombre: "sum", color: .marca)
                        }
                    }
                }

                // Ⓐ Aviso cuando el total llega a S/ 5,000
                if requiereAprobacion {
                    Section {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Requiere aprobación").font(.subheadline.weight(.semibold))
                                Text("Supera S/ 5,000: quedará pendiente de aprobación del supervisor. No cambia stock ni costo promedio todavía.")
                                    .font(.footnote)
                            }
                        } icon: {
                            Image(systemName: "exclamationmark.shield.fill")
                        }
                        .foregroundStyle(.orange)
                    }
                    .listRowBackground(Color.yellow.opacity(0.18))
                }
            }

            // ⑦ Botón: "Enviar a aprobación" o "Registrar compra"
            Section {
                Button(action: registrar) {
                    Label(requiereAprobacion ? "Enviar a aprobación" : "Registrar compra",
                          systemImage: requiereAprobacion ? "paperplane.fill" : "checkmark.circle.fill")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .tint(requiereAprobacion ? .orange : .marca)
                .disabled(!formularioValido)
            } footer: {
                Text("Registrada por \(sesion.usuario?.nombre ?? "—")")
                    .frame(maxWidth: .infinity)
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
        .onChange(of: producto) {
            // Sugiere el último costo promedio del producto
            if let producto { costoTexto = String(format: "%.2f", producto.costoPromedio) }
        }
    }

    private func registrar() {
        guard let costo else { return }
        do {
            registrada = try ReglasCompra.registrarCompra(
                cantidad: cantidad,
                costoUnitario: ReglasCompra.redondear(costo),
                alCredito: alCredito,
                fecha: fecha,
                comprador: sesion.usuario,          // Quién la registró (relación con Usuario)
                proveedor: proveedor,
                producto: producto,
                en: contexto)
        } catch {
            self.error = error.localizedDescription
        }
    }

    private func limpiar() {
        producto = nil
        cantidad = 1
        costoTexto = ""
        alCredito = false
        fecha = .now
    }
}

/// Confirmación después de registrar
struct CompraRegistradaView: View {
    @Environment(\.dismiss) private var dismiss
    let compra: Compra
    let alCerrar: () -> Void

    private var pendiente: Bool { compra.estadoCompra == .pendiente }

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: pendiente ? "clock.badge.checkmark.fill" : "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(pendiente ? .orange : .green)
                .symbolEffect(.bounce, value: compra.codigo)
            VStack(spacing: 6) {
                Text(pendiente ? "Enviada a aprobación" : "Compra registrada")
                    .font(.title2.bold())
                Text(compra.codigo)
                    .font(.headline.monospaced())
                    .foregroundStyle(.secondary)
            }
            VStack(spacing: 10) {
                LabeledContent("Producto", value: compra.producto?.nombre ?? "—")
                LabeledContent("Total", value: compra.total.soles)
                LabeledContent("Estado", value: compra.estado)
                LabeledContent("Pago", value: compra.alCredito ? "Crédito · vence \(compra.vence.corta)" : "Contado · pagada")
            }
            .font(.subheadline)
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
            Text(pendiente
                 ? "El supervisor la revisará. Puedes seguir su estado en Mis compras."
                 : "El stock y el costo promedio del producto ya se actualizaron.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                alCerrar()
                dismiss()
            } label: {
                Text("Listo").fontWeight(.semibold).frame(maxWidth: .infinity).padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .presentationDetents([.medium, .large])
        .interactiveDismissDisabled()
    }
}
