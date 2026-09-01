import Foundation

print("PLAN DE PAGO")
print("-------------------------")

print("Ingrese el nombre del producto:")
let producto = readLine() ?? ""

print("Ingrese el precio:")
let precio = Double(readLine() ?? "") ?? 0

print("Ingrese la cantidad:")
let cantidad = Int(readLine() ?? "") ?? 0

let montoCompra = precio * Double(cantidad)

print("-------------------------")
print("Producto: \(producto)")
print("Precio unitario: S/ \(precio)")
print("Cantidad: \(cantidad)")
print("Monto total de la compra: S/ \(montoCompra)")
print("-------------------------")
print("Seleccione el plan de pago:")
print("1. 6 meses")
print("2. 12 meses")
print("3. 24 meses")

let opcion = Int(readLine() ?? "") ?? 0

var meses = 0

if opcion == 1 {
    meses = 6
} else if opcion == 2 {
    meses = 12
} else if opcion == 3 {
    meses = 24
} else {
    print("Opción no válida")
}

if meses > 0 {
    print("-------------------------")
    print("Plan seleccionado: \(meses) meses")
}
