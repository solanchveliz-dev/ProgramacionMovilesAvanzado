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
//segundo commit

