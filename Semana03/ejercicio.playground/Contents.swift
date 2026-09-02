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
