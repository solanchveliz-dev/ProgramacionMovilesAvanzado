import SwiftUI
import SwiftData

/// B4 · Proveedores (fiel a la maqueta)
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

    var body: some View {
        NavigationStack {
            List {
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
                        FilaProveedor(proveedor: proveedor)          // ②
                    }
                    .deleteDisabled(!esSupervisor)
                }
                .onDelete(perform: borrar)
            }
            .searchable(text: $busqueda, prompt: "Buscar por razón social o RUC")
            .navigationTitle("Proveedores")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if esSupervisor {                                // ① + solo supervisor
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

/// Logo cuadrado de color con las iniciales (cada proveedor tiene su color)
struct LogoProveedor: View {
    let nombre: String
    var tamano: CGFloat = 44

    private static let colores: [Color] = [.teal, .blue, .purple, .orange, .pink, .green, .indigo]

    private var iniciales: String {
        let palabras = nombre.split(separator: " ").filter { $0.count > 2 }.prefix(2)
        let texto = palabras.compactMap { $0.first.map(String.init) }.joined()
        return texto.isEmpty ? String(nombre.prefix(1)) : texto.uppercased()
    }

    /// Color fijo según el nombre (siempre el mismo para el mismo proveedor)
    private var color: Color {
        let suma = nombre.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return Self.colores[suma % Self.colores.count]
    }

    var body: some View {
        Text(iniciales)
            .font(.system(size: tamano * 0.38, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: tamano, height: tamano)
            .background(color, in: RoundedRectangle(cornerRadius: tamano * 0.26, style: .continuous))
    }
}

/// Insignia "N por pagar" (roja) o "Al día" (verde), como en la maqueta
struct InsigniaDeuda: View {
    let alDia: Bool
    var cantidad: Int = 0

    var body: some View {
        Text(alDia ? "Al día" : (cantidad > 0 ? "\(cantidad) por pagar" : "Por pagar"))
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(alDia ? Color.green : Color.red, in: Capsule())
            .foregroundStyle(.white)
    }
}

/// ② Fila: logo, nombre, RUC, total comprado e insignia · ③ valores calculados desde sus compras
struct FilaProveedor: View {
    let proveedor: Proveedor

    private var cuentasPorPagar: Int {
        proveedor.comprasAprobadas.filter { $0.alCredito && !$0.pagada }.count
    }

    var body: some View {
        HStack(spacing: 12) {
            LogoProveedor(nombre: proveedor.nombre)
            VStack(alignment: .leading, spacing: 3) {
                Text(proveedor.nombre)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text("RUC …\(proveedor.ruc.suffix(4))")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 6)
            VStack(alignment: .trailing, spacing: 1) {
                Text(proveedor.totalComprado.soles)
                    .font(.subheadline.weight(.bold))
                    .monospacedDigit()
                Text("comprado")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            InsigniaDeuda(alDia: proveedor.estaAlDia, cantidad: cuentasPorPagar)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ProveedoresView()
        .environment(Sesion())
        .modelContainer(for: [Usuario.self, Proveedor.self, Producto.self, Compra.self], inMemory: true)
}
