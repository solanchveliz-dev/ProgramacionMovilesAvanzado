import Foundation

let igv = 0.18

func CalcularDeacuento(cantidad: Int, subtotal: Double) -> Double {
    if cantidad > 10 {
        return subtotal * 0.15
    } else if cantidad > 5 {
        return subtotal * 0.10
    } else {
        return 0.0
    }
}

print("ingrese el nombre del producto")
let producto = readLine() ?? ""

print("ingrese el precio del producto")
let precio = Double(readLine() ?? "0") ?? 0.0

print("ingrese la cantidad de productos")
let cantidad = Int(readLine() ?? "0") ?? 0

let subtotal = Double(cantidad) * precio
let descuento = CalcularDeacuento(cantidad: cantidad, subtotal: subtotal)

// hallar el monto base: subtotal - descuento
let total = subtotal - descuento

// hallar el igv: monto base * igv
let igvtotal = total * igv

// total: monto base + igv
let totalfinal = total + igvtotal

//hallar el montobase: subtotal - descuento
// hallar el igv el montobase*igv
//total :montobase + igv
// primer commmit
//mostrar los datos
// mostrar los datos

print("")
print("========================================")
print("              FACTURA")
print("========================================")
print("Producto       : \(producto)")
print("Precio unitario: S/ \(String(format: "%.2f", precio))")
print("Cantidad       : \(cantidad)")
print("----------------------------------------")
print("Subtotal       : S/ \(String(format: "%.2f", subtotal))")
print("Descuento      : S/ \(String(format: "%.2f", descuento))")
print("Monto base     : S/ \(String(format: "%.2f", total))")
print("IGV (18%)      : S/ \(String(format: "%.2f", igvtotal))")
print("----------------------------------------")
print("TOTAL A PAGAR  : S/ \(String(format: "%.2f", totalfinal))")
print("========================================")
print("        Gracias por su compra")
print("========================================")

//segundo commit

