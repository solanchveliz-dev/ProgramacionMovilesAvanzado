import SwiftUI
import SwiftData

/// Detalle del proveedor: ③ valores calculados desde sus compras
struct ProveedorDetalleView: View {
    @Environment(Sesion.self) private var sesion
    let proveedor: Proveedor
    @State private var editar = false

    private var compras: [Compra] { proveedor.compras.sorted { $0.fecha > $1.fecha } }

    var body: some View {
        List {
            Section {
                VStack(spacing: 10) {
                    LogoProveedor(nombre: proveedor.nombre, tamano: 84)
                    Text(proveedor.nombre)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    Text("RUC \(proveedor.ruc)")
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.secondary)
                    InsigniaDeuda(alDia: proveedor.estaAlDia)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)

            Section("Resumen") {
                LabeledContent("Total comprado", value: proveedor.totalComprado.soles)
                LabeledContent("Pendiente de pago", value: proveedor.deudaPendiente.soles)
                LabeledContent("Compras aprobadas", value: "\(proveedor.comprasAprobadas.count)")
            }

            Section("Compras") {
                if compras.isEmpty {
                    Text("Aún no hay compras a este proveedor.")
                        .foregroundStyle(.secondary)
                }
                ForEach(compras) { compra in
                    NavigationLink {
                        CompraDetalleView(compra: compra)
                    } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("\(compra.codigo) · \(compra.producto?.nombre ?? "—")")
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(1)
                            Text("\(compra.fecha.corta) · \(compra.alCredito ? "Crédito" : "Contado") · \(compra.estado)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(compra.total.soles)
                            .font(.subheadline.weight(.medium))
                            .monospacedDigit()
                    }
                    }
                }
            }
        }
        .navigationTitle("Proveedor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if sesion.usuario?.esSupervisor == true {
                Button("Editar") { editar = true }
            }
        }
        .sheet(isPresented: $editar) { ProveedorFormView(proveedor: proveedor) }
    }
}
