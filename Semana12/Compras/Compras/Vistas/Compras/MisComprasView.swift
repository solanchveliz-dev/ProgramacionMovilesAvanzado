import SwiftUI
import SwiftData

/// B6 · Mis compras (fiel a la maqueta): el comprador solo ve las suyas
struct MisComprasView: View {
    @Environment(Sesion.self) private var sesion
    @Query(sort: \Compra.fecha, order: .reverse) private var todas: [Compra]

    enum Filtro: String, CaseIterable, Identifiable {
        case todas = "Todas", pendientes = "Pendientes", rechazadas = "Rechazadas"
        var id: String { rawValue }
    }

    @State private var filtro: Filtro = .todas
    @State private var busqueda = ""

    /// ④ El comprador solo ve las suyas (relación compra.comprador)
    private var mias: [Compra] {
        guard let usuario = sesion.usuario else { return [] }
        return todas.filter { $0.comprador?.persistentModelID == usuario.persistentModelID }
    }

    private var visibles: [Compra] {
        mias.filter { c in
            let pasaFiltro: Bool
            switch filtro {
            case .todas: pasaFiltro = true
            case .pendientes: pasaFiltro = c.estadoCompra == .pendiente
            case .rechazadas: pasaFiltro = c.estadoCompra == .rechazada
            }
            let pasaBusqueda = busqueda.isEmpty
                || (c.proveedor?.nombre.localizedCaseInsensitiveContains(busqueda) ?? false)
            return pasaFiltro && pasaBusqueda
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // ① Segmented Todas / Pendientes / Rechazadas
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
                        ContentUnavailableView(mias.isEmpty ? "Aún no tienes compras" : "Sin resultados",
                                               systemImage: "cart",
                                               description: Text(mias.isEmpty ? "Registra tu primera compra en la pestaña Compra."
                                                                              : "Prueba con otro filtro o búsqueda."))
                            .listRowBackground(Color.clear)
                    }
                    ForEach(visibles) { compra in
                        NavigationLink {
                            CompraDetalleView(compra: compra)
                        } label: {
                            FilaMiCompra(compra: compra)            // ② ③
                        }
                    }
                } footer: {
                    if !mias.isEmpty {
                        Text("Solo ves tus compras. El supervisor las aprueba y las paga.")
                    }
                }
            }
            .listSectionSpacing(12)
            .searchable(text: $busqueda, prompt: "Buscar por proveedor")
            .navigationTitle("Mis compras")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) { AvatarMenu() }
            }
        }
    }
}

/// Fila como en la maqueta: ícono de estado, proveedor, "Producto × cantidad · fecha", total e insignia
struct FilaMiCompra: View {
    let compra: Compra

    private var estilo: (icono: String, color: Color) {
        switch compra.estadoCompra {
        case .pendiente: return ("hourglass", .orange)
        case .aprobada: return ("checkmark", .green)
        case .rechazada: return ("xmark", .red)
        }
    }

    private var fechaCorta: String {
        compra.fecha.formatted(.dateTime.day(.twoDigits).month(.twoDigits))
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: estilo.icono)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(estilo.color, in: RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(compra.proveedor?.nombre ?? "Proveedor")
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                Text("\(compra.producto?.nombre ?? "Producto") × \(compra.cantidad) · \(fechaCorta)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                // ③ Compra rechazada con su motivo
                if compra.estadoCompra == .rechazada, let motivo = compra.motivoRechazo {
                    Text("Motivo: \(motivo)")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.red)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 6)

            VStack(alignment: .trailing, spacing: 5) {
                Text(compra.total.soles)
                    .font(.subheadline.weight(.bold))
                    .monospacedDigit()
                Text(compra.estado)
                    .font(.caption2.weight(.bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(estilo.color, in: Capsule())
                    .foregroundStyle(.white)
            }
        }
        .padding(.vertical, 4)
    }
}
