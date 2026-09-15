// ===== CASO 1.5: HERENCIA Y POLIMORFISMO =====

// MARK: - Categorías

enum CategoriaElectro {
    case lineaBlanca
    case tecnologia
    case pequenos
}

// MARK: - Electrodoméstico

struct Electrodomestico {
    let nombre: String
    let marca: String
    let precioLista: Double
    let categoria: CategoriaElectro
}

// MARK: - Clase base

class Sucursal {
    let nombre: String
    let ciudad: String

    init(nombre: String, ciudad: String) {
        self.nombre = nombre
        self.ciudad = ciudad
    }

    // Regla general: descuento del 5 %
    func descuento() -> Double {
        return 0.05
    }

    // Regla general: envío de S/ 30
    func costoEnvio(monto: Double) -> Double {
        return 30.0
    }

    /*
     Este método define todo el flujo de la cotización.
     No debe sobrescribirse en las subclases.
    */
    func cotizar(item: Electrodomestico) {
        let precioConDescuento =
            item.precioLista * (1 - descuento())

        let envio =
            costoEnvio(monto: precioConDescuento)

        let total =
            precioConDescuento + envio

        print(
            "\(nombre): \(item.nombre) -> " +
            "S/ \(precioConDescuento) + " +
            "envío S/ \(envio) = S/ \(total)"
        )
    }
}

// MARK: - TODO 14: Sucursal Lima

class SucursalLima: Sucursal {

    // Lima ofrece 10 % de descuento
    override func descuento() -> Double {
        return 0.10
    }

    /*
     El envío es gratis cuando el monto es
     mayor o igual que S/ 1500.
    */
    override func costoEnvio(monto: Double) -> Double {
        if monto >= 1500 {
            return 0.0
        } else {
            return 30.0
        }
    }
}

// MARK: - TODO 15: Sucursal Provincia

class SucursalProvincia: Sucursal {

    /*
     No sobrescribimos descuento().
     Por eso hereda el descuento de 5 %.

     El envío cuesta 8 % del monto,
     pero como mínimo debe costar S/ 50.
    */
    override func costoEnvio(monto: Double) -> Double {
        let costoCalculado = monto * 0.08

        if costoCalculado < 50 {
            return 50.0
        } else {
            return costoCalculado
        }
    }
}

// MARK: - TODO 16: Sucursal Outlet

class SucursalOutlet: Sucursal {

    // Outlet ofrece 25 % de descuento
    override func descuento() -> Double {
        return 0.25
    }

    // No existe envío: solo recojo en tienda
    override func costoEnvio(monto: Double) -> Double {
        return 0.0
    }
}

// MARK: - TODO 18: Prueba del polimorfismo

class SucursalOnline: Sucursal {

    // Mantiene el descuento base de 5 %
    // y cambia únicamente el costo de envío.
    override func costoEnvio(monto: Double) -> Double {
        return 15.0
    }
}

// MARK: - Productos

let refrigeradora = Electrodomestico(
    nombre: "Refrigeradora",
    marca: "Frost",
    precioLista: 2000.0,
    categoria: .lineaBlanca
)

let licuadora = Electrodomestico(
    nombre: "Licuadora",
    marca: "Mix",
    precioLista: 250.0,
    categoria: .pequenos
)

// MARK: - Arreglo polimórfico

let sucursales: [Sucursal] = [
    SucursalLima(
        nombre: "Lima Centro",
        ciudad: "Lima"
    ),
    SucursalProvincia(
        nombre: "Provincia Cusco",
        ciudad: "Cusco"
    ),
    SucursalOutlet(
        nombre: "Outlet Ate",
        ciudad: "Lima"
    ),
    SucursalOnline(
        nombre: "Tienda Online",
        ciudad: "Virtual"
    )
]

// MARK: - Recorrido polimórfico

print("===== Refrigeradora (S/ 2000.0) =====")

for sucursal in sucursales {
    sucursal.cotizar(item: refrigeradora)
}

print("===== Licuadora (S/ 250.0) =====")

for sucursal in sucursales {
    sucursal.cotizar(item: licuadora)
}
// ===== FIX: Este código tiene 2 errores =====

// FIX 7
class SucursalMall: Sucursal {
    override func descuento() -> Double {
        return 0.12
    }
}

// FIX 8
class SucursalExpress: Sucursal {
    let radioKm: Int

    init(nombre: String, ciudad: String, radioKm: Int) {
        self.radioKm = radioKm
        super.init(nombre: nombre, ciudad: ciudad)
    }
}

// ===== PREDICT: ¿Qué imprime? =====

let misteriosa: Sucursal = SucursalLima(
    nombre: "Lima Centro",
    ciudad: "Lima"
)

print(misteriosa.descuento())
// PREDICT 6: Imprime 0.1.
// El objeto real es SucursalLima, por eso Swift
// ejecuta su versión sobrescrita de descuento().

let monto = 2000.0 * (1 - misteriosa.descuento())

print(misteriosa.costoEnvio(monto: monto))
// PREDICT 7: Imprime 0.0.
// El monto es S/ 1800 y Lima ofrece envío gratis
// cuando el monto es mayor o igual a S/ 1500.
