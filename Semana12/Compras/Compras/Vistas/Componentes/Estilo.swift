import SwiftUI
import UIKit

// MARK: - Componentes visuales reutilizables de toda la app

/// Nivel de stock: verde más de 10 · ámbar de 6 a 10 · rojo 5 o menos
enum NivelStock {
    case alto, medio, bajo

    init(_ stock: Int) {
        if stock > 10 { self = .alto } else if stock >= 6 { self = .medio } else { self = .bajo }
    }

    var color: Color {
        switch self {
        case .alto: return .green
        case .medio: return .orange
        case .bajo: return .red
        }
    }

    var texto: String {
        switch self {
        case .alto: return "En stock"
        case .medio: return "Stock medio"
        case .bajo: return "Stock bajo"
        }
    }
}

/// Píldora de stock con color + texto (no solo color, por accesibilidad)
struct EtiquetaStock: View {
    let stock: Int

    var body: some View {
        let nivel = NivelStock(stock)
        HStack(spacing: 5) {
            Circle().fill(nivel.color).frame(width: 7, height: 7)
            Text("\(stock) u.")
                .font(.caption.weight(.semibold))
                .monospacedDigit()
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .background(nivel.color.opacity(0.14), in: Capsule())
        .foregroundStyle(nivel.color)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(stock) unidades, \(nivel.texto)")
    }
}

/// Foto del producto o, si no tiene, el ícono de su categoría
struct MiniaturaProducto: View {
    let foto: Data?
    let categoria: String
    var tamano: CGFloat = 52

    var body: some View {
        Group {
            if let foto, let imagen = UIImage(data: foto) {
                Image(uiImage: imagen)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    LinearGradient(colors: [.indigo.opacity(0.20), .blue.opacity(0.10)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image(systemName: Categoria.icono(de: categoria))
                        .font(.system(size: tamano * 0.40, weight: .medium))
                        .foregroundStyle(.indigo)
                }
            }
        }
        .frame(width: tamano, height: tamano)
        .clipShape(RoundedRectangle(cornerRadius: tamano * 0.24, style: .continuous))
    }
}

/// Chip de filtro (categorías, estados)
struct ChipFiltro: View {
    let titulo: String
    var icono: String? = nil
    let seleccionado: Bool
    let accion: () -> Void

    var body: some View {
        Button(action: accion) {
            HStack(spacing: 6) {
                if let icono { Image(systemName: icono).font(.caption) }
                Text(titulo)
            }
            .font(.subheadline.weight(.medium))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(seleccionado ? Color.indigo : Color(.secondarySystemGroupedBackground), in: Capsule())
            .foregroundStyle(seleccionado ? Color.white : Color.primary)
        }
        .buttonStyle(.plain)
        .animation(.snappy, value: seleccionado)
    }
}

/// Tarjeta principal con degradado (cifra más importante de la pantalla)
struct TarjetaDestacada: View {
    let titulo: String
    let valor: String
    let detalle: String
    let icono: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(titulo, systemImage: icono)
                .font(.subheadline.weight(.medium))
                .opacity(0.9)
            Text(valor)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(detalle)
                .font(.footnote)
                .opacity(0.85)
        }
        .foregroundStyle(.white)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [.indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .shadow(color: .indigo.opacity(0.25), radius: 12, y: 6)
    }
}
