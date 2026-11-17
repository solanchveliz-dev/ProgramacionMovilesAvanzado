import Foundation
import SwiftData

@Model
final class Producto {
    var nombre: String
    var categoria: String
    var stock: Int
    var costoPromedio: Double       // Costo promedio ponderado SIN IGV

    // La foto se guarda fuera de la tabla SQLite para no hacerla pesada
    @Attribute(.externalStorage) var foto: Data?

    // Un producto tiene muchas compras. .deny: no se borra si tiene compras
    @Relationship(deleteRule: .deny, inverse: \Compra.producto)
    var compras: [Compra] = []

    init(nombre: String, categoria: String, stock: Int, costoPromedio: Double, foto: Data? = nil) {
        self.nombre = nombre
        self.categoria = categoria
        self.stock = stock
        self.costoPromedio = costoPromedio
        self.foto = foto
    }

    // MARK: - Calculado
    /// Valor del inventario de este producto = stock × costo promedio
    var valorInventario: Double { Double(stock) * costoPromedio }
}

/// Categorías del catálogo, cada una con su ícono (se usa cuando no hay foto)
enum Categoria: String, CaseIterable, Identifiable {
    case computo = "Cómputo"
    case accesorios = "Accesorios"
    case redes = "Redes"
    case impresion = "Impresión"
    case oficina = "Oficina"
    case otros = "Otros"

    var id: String { rawValue }

    var icono: String {
        switch self {
        case .computo: return "laptopcomputer"
        case .accesorios: return "computermouse"
        case .redes: return "wifi.router"
        case .impresion: return "printer"
        case .oficina: return "paperclip"
        case .otros: return "shippingbox"
        }
    }

    static func icono(de nombre: String) -> String {
        Categoria(rawValue: nombre)?.icono ?? "shippingbox"
    }
}
