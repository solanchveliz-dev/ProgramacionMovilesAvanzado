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
print("Precio: S/ \(precio)")
print("Cantidad: \(cantidad)")
print("Monto total: S/ \(montoCompra)")
print("-------------------------")
