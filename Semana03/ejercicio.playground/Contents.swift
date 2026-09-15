// Desarrollado por: Naomi Veliz

import Foundation

// ===== TODO 1: Registro de 5 alumnos =====
var alumnos: [String] = []

for i in 1...5 {
    print("Nombre del alumno \(i):")
    let nombre = readLine() ?? ""
    alumnos.append(nombre)
}

print("Alumnos: \(alumnos)")

// ===== TODO 2: Buscar un alumno =====
print("Buscar alumno:")
let buscar = readLine() ?? ""

if alumnos.contains(buscar) {
    print("\(buscar) está en la lista")
} else {
    print("\(buscar) NO está en la lista")
}

// ===== TODO 3: Notas con clasificación =====
var notasClase: [Double] = []

for i in 1...5 {
    print("Nota del alumno \(i):")
    let n = Double(readLine() ?? "") ?? 0
    notasClase.append(n)
}

var aprobados = 0
var desaprobados = 0
var sumaNotas = 0.0

for nota in notasClase {
    sumaNotas += nota

    if nota >= 13 {
        aprobados += 1
    } else {
        desaprobados += 1
    }
}

print("Promedio: \(sumaNotas / Double(notasClase.count))")
print("Aprobados: \(aprobados), Desaprobados: \(desaprobados)")

// ===== FIX =====
var frutas = ["Manzana", "Plátano", "Naranja"]
frutas.append("Pera")

var colores = ["Rojo", "Azul", "Verde"]
colores.append("Amarillo")

let numeros = [10, 20, 30, 40, 50]
print(numeros[4])

// ===== PREDICT =====
var lista = [1, 2, 3, 4, 5]
lista.remove(at: 0)
lista.append(6)

print(lista)
print(lista.count)

var nombres = ["Ana", "Carlos", "Beto"]
print(nombres.sorted())
print(nombres)

// Desarrollado por: Juan Leon

import Foundation

var contactos: [String: String] = [:]

for i in 1...3 {
    print("\nContacto \(i) - Nombre:")
    let nombre = readLine() ?? ""

    print("Teléfono:")
    let telefono = readLine() ?? ""

    contactos[nombre] = telefono
}

print("\n===== DIRECTORIO =====")

for (nombre, telefono) in contactos {
    print("\(nombre): \(telefono)")
}

print("\nBuscar contacto:")
let buscarContactos = readLine() ?? ""

if let tel = contactos[buscar] {
    print("Teléfono de \(buscar): \(tel)")
} else {
    print("\(buscar) no encontrado")
}



// ===== TODO 4: Catálogo de productos =====
//Naomi Veliz
var productos: [String: Double] = [:]

for i in 1...4 {
    print("Producto \(i) - Nombre:")
    let nombreProducto = readLine() ?? ""

    print("Precio:")
    let precioProducto = Double(readLine() ?? "") ?? 0

    productos[nombreProducto] = precioProducto
}


// ===== TODO 5: Mostrar catálogo =====
print("===== CATÁLOGO =====")

for (nombreProducto, precioProducto) in productos {
    print("\(nombreProducto): S/. \(precioProducto)")
}


// ===== TODO 6: Valor total =====
var valorTotal = 0.0

for (_, precioProducto) in productos {
    valorTotal += precioProducto
}

print("Valor total: S/. \(valorTotal)")


// ===== TODO 7: Buscar producto =====
print("Buscar producto:")
let buscarProd = readLine() ?? ""

if let precioEncontrado = productos[buscarProd] {
    print("\(buscarProd) cuesta S/. \(precioEncontrado)")
} else {
    print("Producto no encontrado")
}


// ===== ANALYZE =====
var edades: [String: Int] = [
    "Ana": 20,
    "Luis": 22,
    "María": 19
]

var mayores: [String] = []

for (nombrePersona, edad) in edades {
    if edad >= 21 {
        mayores.append(nombrePersona)
    }
}

print("Mayores de 21: \(mayores)")


// ===== EJERCICIO 3: SETS =====
// Ejemplo resuelto: Alumnos en cursos

var alumnosIOS: Set<String> = []

print("===== ALUMNOS iOS =====")
for i in 1...3 {
    print("Alumno \(i):")
    let nombreIOS = readLine() ?? ""
    alumnosIOS.insert(nombreIOS)
}

var alumnosAndroid: Set<String> = []

print("\n===== ALUMNOS ANDROID =====")
for i in 1...3 {
    print("Alumno \(i):")
    let nombreAndroid = readLine() ?? ""
    alumnosAndroid.insert(nombreAndroid)
}

let enAmbos = alumnosIOS.intersection(alumnosAndroid)
let todos = alumnosIOS.union(alumnosAndroid)
let soloIOS = alumnosIOS.subtracting(alumnosAndroid)
let soloAndroid = alumnosAndroid.subtracting(alumnosIOS)

print("\n===== RESULTADOS =====")
print("En ambos cursos: \(enAmbos)")
print("Todos los alumnos: \(todos)")
print("Solo iOS: \(soloIOS)")
print("Solo Android: \(soloAndroid)")

//Desarrollado por Naomi Veliz
// ===== TODO 8: Eliminar duplicados =====

var numerosIngresados: [Int] = []

for i in 1...8 {
    print("Número \(i):")
    let n = Int(readLine() ?? "") ?? 0
    numerosIngresados.append(n)
}

print("Con duplicados: \(numerosIngresados)")

let sinDuplicados = Array(Set(numerosIngresados)).sorted()

print("Sin duplicados: \(sinDuplicados)")


// ===== TODO 9: Comparar asistencia =====
var asistenciaLunes: Set<String> = []
var asistenciaMartes: Set<String> = []

print("\n===== ASISTENCIA LUNES =====")

for i in 1...4 {
    print("Alumno \(i):")
    let alumnoLunes = readLine() ?? ""
    asistenciaLunes.insert(alumnoLunes)
}

print("\n===== ASISTENCIA MARTES =====")

for i in 1...4 {
    print("Alumno \(i):")
    let alumnoMartes = readLine() ?? ""
    asistenciaMartes.insert(alumnoMartes)
}

let ambosDias = asistenciaLunes.intersection(asistenciaMartes)
let soloLunes = asistenciaLunes.subtracting(asistenciaMartes)
let soloMartes = asistenciaMartes.subtracting(asistenciaLunes)

print("Ambos días: \(ambosDias)")
print("Solo lunes: \(soloLunes)")
print("Solo martes: \(soloMartes)")


// ===== PREDICT =====
let a: Set = [1, 2, 3, 4, 5]
let b: Set = [4, 5, 6, 7, 8]

print(a.intersection(b))
print(a.union(b).count)
print(a.subtracting(b))

var repetidos: Set = ["A", "B", "A", "C", "B"]
print(repetidos.count)

// ===== EJERCICIO 4: COMBINACIÓN DE COLECCIONES =====
// Ejemplo resuelto: Sistema de notas

var notasPa: [String: Double] = [:]
var notasPb: [String: Double] = [:]

print("¿Cuántos alumnos?")
let cantidadAlumnos = Int(readLine() ?? "") ?? 0

for i in 1...cantidadAlumnos {
    print("\nAlumno \(i) - Nombre:")
    let nombreAlumno = readLine() ?? ""

    print("Nota Pa:")
    let pa = Double(readLine() ?? "") ?? 0

    print("Nota Pb:")
    let pb = Double(readLine() ?? "") ?? 0

    notasPa[nombreAlumno] = pa
    notasPb[nombreAlumno] = pb
}

print("\n===== REPORTE =====")

var totalAprobados = 0
var sumaGeneral = 0.0

for (alumno, pa) in notasPa {
    if let pb = notasPb[alumno] {

        let notaFinal = 0.30 * pa + 0.70 * pb
        let estado = notaFinal >= 13.0 ? "Aprobado" : "Desaprobado"

        print("\(alumno): Pa=\(pa) Pb=\(pb) Final=\(notaFinal) → \(estado)")

        sumaGeneral += notaFinal

        if notaFinal >= 13.0 {
            totalAprobados += 1
        }
    }
}

print("Promedio general: \(sumaGeneral / Double(notasPa.count))")
print("Aprobados: \(totalAprobados) de \(notasPa.count)")

// ===== TODO 10: Inventario de productos =====

var preciosInventario: [String: Double] = [:]
var stocksInventario: [String: Int] = [:]

print("¿Cuántos productos?")
let cantidadProductos = Int(readLine() ?? "") ?? 0

if cantidadProductos > 0 {

    for i in 1...cantidadProductos {

        print("Producto \(i) - Nombre:")
        let nombreProductoInv = readLine() ?? ""

        print("Precio:")
        let precioProductoInv = Double(readLine() ?? "") ?? 0

        print("Stock:")
        let stockProductoInv = Int(readLine() ?? "") ?? 0

        preciosInventario[nombreProductoInv] = precioProductoInv
        stocksInventario[nombreProductoInv] = stockProductoInv
    }

    var valorInventario = 0.0

    for (nombreProductoInv, precioProductoInv) in preciosInventario {

        if let stockProductoInv = stocksInventario[nombreProductoInv] {
            valorInventario += precioProductoInv * Double(stockProductoInv)
        }
    }

    print("Valor total del inventario: S/. \(valorInventario)")

    print("===== STOCK BAJO =====")

    for (nombreProductoInv, stockProductoInv) in stocksInventario {

        if stockProductoInv < 5 {
            print("\(nombreProductoInv): \(stockProductoInv) unidades")
        }
    }

} else {
    print("Debe ingresar una cantidad mayor a 0")
}

// ===== EJERCICIO 5: CARRITO DE COMPRAS 2.0 =====

var nombresCarrito: [String] = []
var preciosCarrito: [Double] = []
var cantidadesCarrito: [Int] = []

// ===== TODO 11: Pedir productos =====

print("¿Cuántos productos va a comprar?")
let totalProductosCarrito = Int(readLine() ?? "") ?? 0

if totalProductosCarrito > 0 {

    for i in 1...totalProductosCarrito {

        print("\nProducto \(i) - Nombre:")
        let nombreCarrito = readLine() ?? ""
        nombresCarrito.append(nombreCarrito)

        print("Precio unitario:")
        let precioCarrito = Double(readLine() ?? "") ?? 0
        preciosCarrito.append(precioCarrito)

        print("Cantidad:")
        let cantidadCarrito = Int(readLine() ?? "") ?? 0
        cantidadesCarrito.append(cantidadCarrito)
    }

    // ===== TODO 12: Calcular subtotales =====

    var subtotalesCarrito: [Double] = []

    for i in 0..<nombresCarrito.count {

        let subCarrito = preciosCarrito[i] * Double(cantidadesCarrito[i])

        subtotalesCarrito.append(subCarrito)
    }

    // ===== TODO 13: Total del carrito =====

    var totalCarritoCompra = 0.0

    for subCarrito in subtotalesCarrito {

        totalCarritoCompra += subCarrito
    }

    // ===== TODO 14: Nombre del cliente =====

    print("\nNombre del cliente:")

    let clienteCarrito = readLine() ?? ""

    // ===== TODO 15: Descuento =====

    var descPctCarrito = 0.0

    if totalCarritoCompra >= 5000 {

        descPctCarrito = 0.15

    } else if totalCarritoCompra >= 2000 {

        descPctCarrito = 0.10

    } else if totalCarritoCompra >= 500 {

        descPctCarrito = 0.05
    }

    let descuentoCarrito = totalCarritoCompra * descPctCarrito

    let totalConDescCarrito = totalCarritoCompra - descuentoCarrito

    // ===== TODO 16: IGV y total =====

    let igvCarrito = totalConDescCarrito * 0.18

    let totalFinalCarrito = totalConDescCarrito + igvCarrito

    // ===== TODO 17: Categoría =====

    var categoriaCarrito = ""

    switch Int(totalCarritoCompra) {

    case 0..<500:
        categoriaCarrito = "Regular"

    case 500..<2000:
        categoriaCarrito = "Frecuente"

    case 2000..<5000:
        categoriaCarrito = "VIP"

    default:
        categoriaCarrito = "Premium"
    }

    // ===== TODO 18: Ticket =====

    let sepCarrito = String(repeating: "=", count: 45)

    print(sepCarrito)

    print(" TICKET DE COMPRA 2.0")

    print(" Cliente: \(clienteCarrito) (\(categoriaCarrito))")

    print(sepCarrito)

    for i in 0..<nombresCarrito.count {

        print("\(nombresCarrito[i]) x\(cantidadesCarrito[i]) S/. \(subtotalesCarrito[i])")
    }

    print(sepCarrito)

    print("Subtotal: S/. \(totalCarritoCompra)")

    if descPctCarrito > 0 {

        print("Descuento (\(descPctCarrito * 100)%): -S/. \(descuentoCarrito)")
    }

    print("IGV (18%): S/. \(igvCarrito)")

    print(sepCarrito)

    print("TOTAL: S/. \(totalFinalCarrito)")

    print(sepCarrito)

    print("¡Gracias por su compra, \(clienteCarrito)!")

} else {

    print("Debe ingresar una cantidad mayor a 0")
}
