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

/// Píldora de stock en color con el número (como en la maqueta: "40 u.")
struct EtiquetaStock: View {
    let stock: Int

    var body: some View {
        let nivel = NivelStock(stock)
        Text("\(stock) u.")
            .font(.caption2.weight(.bold))
            .monospacedDigit()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(nivel.color, in: Capsule())
            .foregroundStyle(.white)
            .accessibilityLabel("\(stock) unidades, \(nivel.texto)")
    }
}

/// Cuadrado de color con iniciales (productos sin foto, proveedores, usuarios)
struct Iniciales: View {
    let nombre: String
    var tamano: CGFloat = 44

    private static let colores: [Color] = [.teal, .blue, .purple, .orange, .pink, .green, .indigo, .red]

    private var texto: String {
        let palabras = nombre.split(separator: " ").filter { $0.count > 2 }.prefix(2)
        let t = palabras.compactMap { $0.first.map(String.init) }.joined()
        return t.isEmpty ? String(nombre.prefix(2)).uppercased() : t.uppercased()
    }

    /// Siempre el mismo color para el mismo nombre
    private var color: Color {
        let suma = nombre.unicodeScalars.reduce(0) { $0 + Int($1.value) }
        return Self.colores[suma % Self.colores.count]
    }

    var body: some View {
        Text(texto)
            .font(.system(size: tamano * 0.36, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: tamano, height: tamano)
            .background(color, in: RoundedRectangle(cornerRadius: tamano * 0.26, style: .continuous))
    }
}

/// Foto del producto; si no tiene, sus iniciales en color (como en la maqueta)
struct MiniaturaProducto: View {
    let foto: Data?
    let categoria: String
    var tamano: CGFloat = 44
    var nombre: String? = nil

    var body: some View {
        if let foto, let imagen = UIImage(data: foto) {
            Image(uiImage: imagen)
                .resizable()
                .scaledToFit()
                .padding(tamano * 0.06)
                .frame(width: tamano, height: tamano)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: tamano * 0.26, style: .continuous))
        } else if let nombre {
            Iniciales(nombre: nombre, tamano: tamano)
        } else {
            Image(systemName: Categoria.icono(de: categoria))
                .font(.system(size: tamano * 0.40, weight: .medium))
                .foregroundStyle(.indigo)
                .frame(width: tamano, height: tamano)
                .background(Color.indigo.opacity(0.14), in: RoundedRectangle(cornerRadius: tamano * 0.26, style: .continuous))
        }
    }
}

/// Chip de filtro
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
            .background(seleccionado ? Color.accentColor : Color(.secondarySystemGroupedBackground), in: Capsule())
            .foregroundStyle(seleccionado ? Color.white : Color.primary)
        }
        .buttonStyle(.plain)
    }
}

/// Tarjeta con degradado (se usa en la pantalla de bienvenida y el detalle)
struct TarjetaDestacada: View {
    let titulo: String
    let valor: String
    let detalle: String
    let icono: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(titulo, systemImage: icono).font(.subheadline.weight(.medium)).opacity(0.9)
            Text(valor).font(.system(size: 32, weight: .bold, design: .rounded)).monospacedDigit()
                .lineLimit(1).minimumScaleFactor(0.6)
            Text(detalle).font(.footnote).opacity(0.85)
        }
        .foregroundStyle(.white)
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [.indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

/// Tarjeta blanca con título pequeño y un valor grande (como en la maqueta)
struct TarjetaValor: View {
    let titulo: String
    let valor: String
    var detalle: String? = nil
    var colorDetalle: Color = .secondary

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(titulo)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(valor)
                    .font(.title3.weight(.bold))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                if let detalle {
                    Text(detalle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(colorDetalle)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

/// Campo con etiqueta pequeña en mayúsculas arriba (login y registro de la maqueta)
struct CampoEtiquetado<Contenido: View>: View {
    let etiqueta: String
    var borde: Color = .clear
    let contenido: Contenido

    init(_ etiqueta: String, borde: Color = .clear, @ViewBuilder contenido: () -> Contenido) {
        self.etiqueta = etiqueta
        self.borde = borde
        self.contenido = contenido()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(etiqueta.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
            contenido
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(borde, lineWidth: 1.5))
    }
}
