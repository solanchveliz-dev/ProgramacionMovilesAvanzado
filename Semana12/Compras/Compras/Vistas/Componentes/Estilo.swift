import SwiftUI
import UIKit

// MARK: - Colores de marca (un solo lugar para toda la app)

extension Color {
    static let marcaInicio = Color(red: 0.06, green: 0.22, blue: 0.28)
    static let marcaFin = Color(red: 0.13, green: 0.43, blue: 0.49)
}

/// Color principal: azul petróleo (como la maqueta).
/// Se puede usar como Color.marca o .marca (en foregroundStyle, tint, etc.)
extension ShapeStyle where Self == Color {
    static var marca: Color { Color(red: 0.11, green: 0.33, blue: 0.40) }
}

extension LinearGradient {
    /// Degradado de marca (splash, login, tarjetas destacadas)
    static var marca: LinearGradient {
        LinearGradient(colors: [.marcaInicio, .marcaFin], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

/// Sombra suave y elegante para tarjetas
extension View {
    func sombraSuave() -> some View {
        shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

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
                .foregroundStyle(.marca)
                .frame(width: tamano, height: tamano)
                .background(Color.marca.opacity(0.12), in: RoundedRectangle(cornerRadius: tamano * 0.26, style: .continuous))
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
            .overlay(Capsule().stroke(seleccionado ? Color.clear : Color(.separator).opacity(0.4), lineWidth: 1))
            .foregroundStyle(seleccionado ? Color.white : Color.primary)
            .shadow(color: seleccionado ? Color.accentColor.opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
            .animation(.snappy(duration: 0.2), value: seleccionado)
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
        .background(alignment: .topTrailing) {
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 22, style: .continuous).fill(LinearGradient.marca)
                // Círculos decorativos, como en apps bancarias
                Circle().fill(.white.opacity(0.10)).frame(width: 140, height: 140).offset(x: 50, y: -50)
                Circle().fill(.white.opacity(0.07)).frame(width: 90, height: 90).offset(x: -10, y: 40)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .shadow(color: Color.marcaInicio.opacity(0.35), radius: 14, x: 0, y: 8)
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
                    .font(.system(.title3, design: .rounded, weight: .bold))
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
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .sombraSuave()
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
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(borde == .clear ? Color(.separator).opacity(0.35) : borde,
                        lineWidth: borde == .clear ? 1 : 1.5)
        )
    }
}

/// Ícono cuadrado de color para las filas de formularios (estilo Ajustes de iPhone)
struct IconoFila: View {
    let nombre: String
    var color: Color = .marca

    var body: some View {
        Image(systemName: nombre)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 28, height: 28)
            .background(color.gradient, in: RoundedRectangle(cornerRadius: 7, style: .continuous))
    }
}

/// Texto con su ícono de color a la izquierda (para usar como etiqueta de una fila)
struct EtiquetaFila: View {
    let titulo: String
    let icono: String
    var color: Color = .marca

    init(_ titulo: String, icono: String, color: Color = .marca) {
        self.titulo = titulo
        self.icono = icono
        self.color = color
    }

    var body: some View {
        Label {
            Text(titulo)
        } icon: {
            IconoFila(nombre: icono, color: color)
        }
    }
}

/// Campo de clave con botón de ojo para mostrar u ocultar (como en apps reales)
struct CampoClave: View {
    let placeholder: String
    @Binding var texto: String
    var icono: String = "lock.fill"
    var alEnviar: () -> Void = {}

    @State private var visible = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icono).foregroundStyle(.secondary)
            Group {
                if visible {
                    TextField(placeholder, text: $texto)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } else {
                    SecureField(placeholder, text: $texto)
                }
            }
            .onSubmit(alEnviar)
            Button {
                visible.toggle()
            } label: {
                Image(systemName: visible ? "eye.slash" : "eye")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(visible ? "Ocultar clave" : "Mostrar clave")
        }
    }
}

/// Subtítulo debajo del título de la pantalla (iOS 26). En versiones anteriores no hace nada.
extension View {
    @ViewBuilder
    func subtitulo(_ texto: String) -> some View {
        if #available(iOS 26.0, *) {
            self.navigationSubtitle(texto)
        } else {
            self
        }
    }
}
