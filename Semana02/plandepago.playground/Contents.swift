import Foundation

print("DATOS DEL PRODUCTO")
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

let entrada = readLine() ?? ""
var meses = 0

if  let opcion = Int(entrada) {
    if opcion == 1 {
    meses = 6
        
    } else if opcion == 2 {
    meses = 12
        
   } else if opcion == 3 {
    meses = 24
       
   } else {
       print("Opción no válida")
   }

} else {
    print("Debe ingresar una opcion numerica")
    
}


if meses > 0 {
        print("-------------------------")
        print("Plan seleccionado: \(meses) meses")
    
    
        var interes = 0.0
        
        if meses == 6 {
            interes = 0.20
        } else if meses == 12 {
            interes = 0.40
        } else if meses == 24 {
            interes = 0.60
        }
        let montoInteres = montoCompra * interes
        let montoFinal = montoCompra + montoInteres
        let cuotaMensual = montoFinal / Double(meses)
        
        print("-------------------------")
        print("PLAN DE PAGO")
        print("Meses: \(meses)")
        print("Interés: \(interes * 100)%")
        print("Monto de compra: S/ \(montoCompra)")
        print("Monto del interés: S/ \(montoInteres)")
        print("Monto final: S/ \(montoFinal)")
        print("Cuota mensual: S/ \(cuotaMensual)")
        
        
        print("-------------------------")
        print("CALENDARIO DE PAGOS")
        print("-------------------------")
        
        var saldoRestante = montoFinal
        
        let calendario = Calendar.current
        let fechaActual = Date()
        
        let formatoFecha = DateFormatter()
        formatoFecha.dateFormat = "dd/MM/yyyy"
        
        for mes in 1...meses {
            
            let fechaPago = calendario.date(
                byAdding: .month,
                value: mes,
                to: fechaActual
            )!
            
            let montoInicial = saldoRestante
            
            var pago = cuotaMensual
            
            if pago > saldoRestante {
                pago = saldoRestante
            }
            
            saldoRestante = saldoRestante - pago
            
            print("Mes: \(mes)")
            print("Fecha: \(formatoFecha.string(from: fechaPago))")
            print("Monto inicial: S/ \(String(format: "%.2f", montoInicial))")
            print("Pago: S/ \(String(format: "%.2f", pago))")
            print("Resta por pagar: S/ \(String(format: "%.2f", saldoRestante))")
            print("-------------------------")
        }
        
    }


    

