import Foundation
import SwiftData
import UIKit

/// Carga un catálogo de ejemplo (proveedores y productos con foto) para presentar la app.
/// No duplica: solo agrega lo que todavía no existe (por RUC o por nombre).
/// Las fotos se toman de Assets con el nombre indicado (si no existe la imagen, queda el ícono de la categoría).
enum DatosDemo {

    private static let proveedores: [(nombre: String, ruc: String)] = [
        ("Distribuidora Andina S.A.C.", "20601234561"),
        ("Tecnología Global E.I.R.L.", "20512345678"),
        ("Importaciones del Pacífico S.A.", "20498765432"),
        ("Suministros Lima S.R.L.", "20556677889")
    ]

    // El primero es el producto base de los casos de prueba: stock 40, costo 110.00
    private static let productos: [(nombre: String, categoria: Categoria, stock: Int, costo: Double, imagen: String)] = [
        ("Laptop Lenovo IdeaPad 3", .computo, 40, 110.00, "prod_laptop"),
        ("Monitor 24\" Full HD", .computo, 12, 420.00, "prod_monitor"),
        ("Mouse inalámbrico", .accesorios, 8, 35.00, "prod_mouse"),
        ("Teclado mecánico", .accesorios, 15, 120.00, "prod_teclado"),
        ("Router Wi-Fi 6", .redes, 3, 180.00, "prod_router"),
        ("Switch de 8 puertos", .redes, 6, 95.00, "prod_switch"),
        ("Impresora multifuncional", .impresion, 4, 650.00, "prod_impresora")
    ]

    /// Foto desde Assets o desde un archivo del proyecto (prod_laptop.png), reducida igual que las que se eligen de la galería
    private static func foto(_ nombre: String) -> Data? {
        guard let imagen = UIImage(named: nombre), let datos = imagen.pngData() else { return nil }
        return ProductoFormView.comprimir(datos)
    }

    /// Devuelve cuántos proveedores y productos agregó
    @discardableResult
    static func cargar(en contexto: ModelContext) -> (proveedores: Int, productos: Int) {
        let existentesProv = (try? contexto.fetch(FetchDescriptor<Proveedor>())) ?? []
        let existentesProd = (try? contexto.fetch(FetchDescriptor<Producto>())) ?? []

        var nuevosProv = 0
        for p in proveedores where !existentesProv.contains(where: { $0.ruc == p.ruc }) {
            contexto.insert(Proveedor(nombre: p.nombre, ruc: p.ruc))
            nuevosProv += 1
        }

        var nuevosProd = 0
        for p in productos {
            if let existente = existentesProd.first(where: { $0.nombre.lowercased() == p.nombre.lowercased() }) {
                // Si ya existía sin foto, le pone la foto de Assets
                if existente.foto == nil { existente.foto = foto(p.imagen) }
            } else {
                contexto.insert(Producto(nombre: p.nombre, categoria: p.categoria.rawValue,
                                         stock: p.stock, costoPromedio: p.costo, foto: foto(p.imagen)))
                nuevosProd += 1
            }
        }

        try? contexto.save()
        return (nuevosProv, nuevosProd)
    }
}
