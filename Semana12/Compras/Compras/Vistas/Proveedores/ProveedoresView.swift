import SwiftUI
import SwiftData

/// B4 · Proveedores
struct ProveedoresView: View {
    @Environment(\.modelContext) private var contexto
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Proveedor.nombre) private var proveedores: [Proveedor]

    @State private var busqueda = ""
    @State private var mostrarNuevo = false
    @State private var mensajeBloqueo: String?

    private var esSupervisor: Bool { sesion.usuario?.esSupervisor ?? false }

    private var filtrados: [Proveedor] {
        guard !busqueda.isEmpty else { return proveedores }
        return proveedores.filter {
            $0.nombre.localizedCaseInsensitiveContains(busqueda) || $0.ruc.contains(busqueda)
        }
    }

    private var deudaTotal: Double { proveedores.reduce(0) { $0 + $1.deudaPendiente } }
    private var conDeuda: Int { proveedores.filter { !$0.estaAlDia }.count }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TarjetaDestacada(titulo: "Deuda con proveedores",
                                     valor: deudaTotal.soles,
                                     detalle: conDeuda == 0
                                        ? "Todos los proveedores al día"
                                        : "\(conDeuda) de \(proveedores.count) proveedores con pagos pendientes",
                                     icono: "building.2.fill")
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                Section {
                    if proveedores.isEmpty {
                        ContentUnavailableView("Sin proveedores", systemImage: "building.2",
                                               description: Text(esSupervisor ? "Toca + para registrar el primero."
                                                                              : "El supervisor aún no registra proveedores."))
                            .listRowBackground(Color.clear)
                    } else if filtrados.isEmpty {
                        ContentUnavailableView("Sin resultados", systemImage: "magnifyingglass",
                                               description: Text("Busca por razón social o RUC."))
                            .listRowBackground(Color.clear)
                    }
                    ForEach(filtrados) { proveedor in
                        NavigationLink {
                            ProveedorDetalleView(proveedor: proveedor)
                        } label: {
                            FilaProveedor(proveedor: proveedor)
                        }
                        .deleteDisabled(!esSupervisor)
                    }
                    .onDelete(perform: borrar)
                } header: {
                    Text(filtrados.count == 1 ? "1 proveedor" : "\(filtrados.count) proveedores")
                }
            }
            .listSectionSpacing(14)
            .searchable(text: $busqueda, prompt: "Buscar por razón social o RUC")
            .navigationTitle("Proveedores")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if esSupervisor {
                        Button { mostrarNuevo = true } label: { Image(systemName: "plus") }
                            .accessibilityLabel("Nuevo proveedor")
                    }
                    AvatarMenu()
                }
            }
            .sheet(isPresented: $mostrarNuevo) { ProveedorFormView(proveedor: nil) }
            .alert("No se puede eliminar",
                   isPresented: Binding(get: { mensajeBloqueo != nil }, set: { if !$0 { mensajeBloqueo = nil } })) {
                Button("Entendido", role: .cancel) { }
            } message: {
                Text(mensajeBloqueo ?? "")
            }
        }
    }

    /// Borrado bloqueado si el proveedor tiene compras (.deny)
    private func borrar(_ offsets: IndexSet) {
        for index in offsets {
            let proveedor = filtrados[index]
            guard proveedor.compras.isEmpty else {
                mensajeBloqueo = "Este proveedor tiene \(proveedor.compras.count) compra(s) registrada(s). Se conserva para no perder el historial."
                return
            }
            contexto.delete(proveedor)
        }
        try? contexto.save()
    }
}

/// Logo circular con las iniciales de la razón social
struct LogoProveedor: View {
    let nombre: String
    var tamano: CGFloat = 46

    private var iniciales: String {
        let palabras = nombre.split(separator: " ").filter { $0.count > 2 }.prefix(2)
        let texto = palabras.compactMap { $0.first.map(String.init) }.joined()
        return texto.isEmpty ? String(nombre.prefix(1)) : texto.uppercased()
    }

    var body: some View {
        Text(iniciales)
            .font(.system(size: tamano * 0.36, weight: .bold, design: .rounded))
            .foregroundStyle(.indigo)
            .frame(width: tamano, height: tamano)
            .background(Color.indigo.opacity(0.12), in: RoundedRectangle(cornerRadius: tamano * 0.28, style: .continuous))
    }
}

/// Insignia "Por pagar" (naranja) o "Al día" (verde)
struct InsigniaDeuda: View {
    let alDia: Bool

    var body: some View {
        Label(alDia ? "Al día" : "Por pagar", systemImage: alDia ? "checkmark.circle.fill" : "clock.fill")
            .font(.caption.weight(.semibold))
            .labelStyle(.titleAndIcon)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background((alDia ? Color.green : Color.orange).opacity(0.14), in: Capsule())
            .foregroundStyle(alDia ? Color.green : Color.orange)
    }
}

/// ② Fila: logo, razón social, RUC, insignia y total comprado
struct FilaProveedor: View {
    let proveedor: Proveedor

    var body: some View {
        HStack(spacing: 12) {
            LogoProveedor(nombre: proveedor.nombre)
            VStack(alignment: .leading, spacing: 3) {
                Text(proveedor.nombre)
                    .font(.body.weight(.semibold))
                    .lineLimit(1)
                Text("RUC \(proveedor.ruc)")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 6) {
                InsigniaDeuda(alDia: proveedor.estaAlDia)
                Text(proveedor.totalComprado.soles)
                    .font(.caption.weight(.medium))
                    .monospacedDigit()
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProveedoresView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
