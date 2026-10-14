

import Foundation

struct Producto {
    let nombre: String
    let precio: Double
    var stock: Int
}

struct ItemCarrito {
    let producto: Producto
    var cantidad: Int

    var subtotal: Double {
        producto.precio * Double(cantidad)
    }
}

class CarritoModel {
    var items: [ItemCarrito] = []

    var subtotal: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }

    var descuento: Double {
        if subtotal >= 5000 {
            return subtotal * 0.15
        } else if subtotal >= 2000 {
            return subtotal * 0.10
        } else if subtotal >= 500 {
            return subtotal * 0.05
        }
        return 0
    }

    var baseImponible: Double {
        subtotal - descuento
    }

    var igv: Double {
        baseImponible * 0.18
    }

    var total: Double {
        baseImponible + igv
    }

    var categoria: String {
        switch Int(subtotal) {
        case ..<500:
            return "Regular"
        case 500..<2000:
            return "Frecuente"
        case 2000..<5000:
            return "VIP"
        default:
            return "Premium"
        }
    }

    func agregar(producto: Producto, cantidad: Int) -> Bool {
        guard cantidad > 0 else { return false }

        let cantidadActual = items.first {
            $0.producto.nombre == producto.nombre
        }?.cantidad ?? 0

        guard cantidadActual + cantidad <= producto.stock else {
            return false
        }

        if let indice = items.firstIndex(where: {
            $0.producto.nombre == producto.nombre
        }) {
            items[indice].cantidad += cantidad
        } else {
            items.append(
                ItemCarrito(producto: producto, cantidad: cantidad)
            )
        }

        return true
    }

    func vaciar() {
        items.removeAll()
    }
}

struct ClienteModel {
    var nombre: String
    var dni: String
    var direccion: String
}
