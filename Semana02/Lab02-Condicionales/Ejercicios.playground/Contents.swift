import Foundation // Importa herramientas básicas de Swift necesarias para trabajar con el programa.

// Guarda el nombre del primer producto.
let prod1 = "Laptop"
// Guarda el precio de una Laptop.
let precio1 = 3500.0
// Guarda la cantidad de laptops compradas.
let cant1 = 1

// Guarda el nombre del segundo producto.
let prod2 = "Mouse"
// Guarda el precio de un Mouse.
let precio2 = 45.50
// Guarda la cantidad de mouse comprados.
let cant2 = 2

// Guarda el nombre del tercer producto.
let prod3 = "Teclado"
// Guarda el precio de un Teclado.
let precio3 = 120.00
// Guarda la cantidad de teclados comprados.
let cant3 = 1

// Guarda el nombre del cuarto producto.
let prod4 = "Monitor"
// Guarda el precio de un Monitor.
let precio4 = 890.00
// Guarda la cantidad de monitores comprados.
let cant4 = 1

// Guarda el nombre del quinto producto.
let prod5 = "USB Cable"
// Guarda el precio de un USB Cable.
let precio5 = 15.00
// Guarda la cantidad de cables USB comprados.
let cant5 = 3

// Guarda el código de cupón que utilizará el cliente.
let cupon = "DESCUENTO20"

// Comprueba que todos los precios sean mayores o iguales a cero y todas las cantidades sean mayores a cero.
if precio1 < 0 || precio2 < 0 || precio3 < 0 || precio4 < 0 || precio5 < 0 ||
   cant1 == 0 || cant2 == 0 || cant3 == 0 || cant4 == 0 || cant5 == 0 {

    // Muestra un mensaje cuando existe un precio negativo o una cantidad igual a cero.
    print("ERROR: Los precios no pueden ser negativos y las cantidades deben ser mayores a 0.")

} else {

    // Calcula el subtotal inicial de la Laptop multiplicando precio por cantidad.
    var sub1 = precio1 * Double(cant1)

    // Calcula el subtotal inicial del Mouse multiplicando precio por cantidad.
    var sub2 = precio2 * Double(cant2)

    // Calcula el subtotal inicial del Teclado multiplicando precio por cantidad.
    var sub3 = precio3 * Double(cant3)

    // Calcula el subtotal inicial del Monitor multiplicando precio por cantidad.
    var sub4 = precio4 * Double(cant4)

    // Calcula el subtotal inicial del USB Cable multiplicando precio por cantidad.
    var sub5 = precio5 * Double(cant5)

    // Comprueba si se compraron 3 o más laptops.
    if cant1 >= 3 {
        // Reduce 5% del subtotal de las laptops cuando se compran 3 o más unidades.
        sub1 = sub1 * 0.95
    }

    // Comprueba si se compraron 3 o más mouse.
    if cant2 >= 3 {
        // Reduce 5% del subtotal de los mouse cuando se compran 3 o más unidades.
        sub2 = sub2 * 0.95
    }

    // Comprueba si se compraron 3 o más teclados.
    if cant3 >= 3 {
        // Reduce 5% del subtotal de los teclados cuando se compran 3 o más unidades.
        sub3 = sub3 * 0.95
    }

    // Comprueba si se compraron 3 o más monitores.
    if cant4 >= 3 {
        // Reduce 5% del subtotal de los monitores cuando se compran 3 o más unidades.
        sub4 = sub4 * 0.95
    }

    // Comprueba si se compraron 3 o más cables USB.
    if cant5 >= 3 {
        // Reduce 5% del subtotal de los cables USB cuando se compran 3 o más unidades.
        sub5 = sub5 * 0.95
    }

    // Suma los subtotales de todos los productos después del descuento por cantidad.
    let subtotalGeneral = sub1 + sub2 + sub3 + sub4 + sub5

    // Guarda inicialmente el subtotal general como total antes de aplicar el cupón.
    var totalConCupon = subtotalGeneral

    // Comprueba si el código ingresado coincide exactamente con DESCUENTO20.
    if cupon == "DESCUENTO20" {
        // Aplica un descuento adicional del 20% al subtotal general.
        totalConCupon = subtotalGeneral * 0.80
    }

    // Guarda inicialmente un costo de envío de S/. 25.
    var envio = 25.0

    // Comprueba si el total después del cupón supera S/. 3000.
    if totalConCupon > 3000 {
        // Establece el envío en cero porque la compra supera S/. 3000.
        envio = 0.0
    }

    // Calcula el monto del IGV correspondiente al 18% del total después de descuentos.
    let igv = totalConCupon * 0.18

    // Calcula el total final sumando el total con descuentos, el IGV y el costo de envío.
    let totalFinal = totalConCupon + igv + envio

    // Calcula los puntos de fidelidad entregando 1 punto por cada S/. 100 del total de compra.
    let puntos = Int(totalFinal / 100)

    // Muestra un título para el resultado del carrito mejorado.
    print("===== CARRITO MEJORADO =====")

    // Muestra el subtotal final de la Laptop.
    print("\(prod1): S/. \(String(format: "%.2f", sub1))")

    // Muestra el subtotal final del Mouse.
    print("\(prod2): S/. \(String(format: "%.2f", sub2))")

    // Muestra el subtotal final del Teclado.
    print("\(prod3): S/. \(String(format: "%.2f", sub3))")

    // Muestra el subtotal final del Monitor.
    print("\(prod4): S/. \(String(format: "%.2f", sub4))")

    // Muestra el subtotal final del USB Cable.
    print("\(prod5): S/. \(String(format: "%.2f", sub5))")

    // Muestra el subtotal de toda la compra después del descuento por cantidad.
    print("Subtotal: S/. \(String(format: "%.2f", subtotalGeneral))")

    // Muestra el código del cupón utilizado.
    print("Cupón: \(cupon)")

    // Muestra el total después de aplicar el cupón cuando corresponde.
    print("Total con cupón: S/. \(String(format: "%.2f", totalConCupon))")

    // Muestra el costo de envío calculado.
    print("Envío: S/. \(String(format: "%.2f", envio))")

    // Muestra el monto correspondiente al IGV.
    print("IGV: S/. \(String(format: "%.2f", igv))")

    // Muestra el total final que debe pagar el cliente.
    print("TOTAL FINAL: S/. \(String(format: "%.2f", totalFinal))")

    // Muestra la cantidad de puntos de fidelidad ganados por el cliente.
    print("Puntos ganados: \(puntos)")
}
