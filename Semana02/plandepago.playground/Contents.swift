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
    print("Monto de compra: S/ \(String(format: "%.2f", montoCompra))")
    print("Monto del interés: S/ \(String(format: "%.2f", montoInteres))")
    print("Monto final: S/ \(String(format: "%.2f", montoFinal))")
    print("Cuota mensual: S/ \(String(format: "%.2f", cuotaMensual))")
    
    print("-------------------------")
    print("¿Desea realizar un adelanto de pago? (SI/NO)")
    
    let respuestaAdelanto = readLine() ?? ""
    
    var mesAdelanto = 0
    var montoAdicional = 0.0
    
    if respuestaAdelanto.uppercased() == "SI" {
        
        print("¿En qué mes realizará el adelanto?")
        mesAdelanto = Int(readLine() ?? "") ?? 0
        
       while mesAdelanto < 1 || mesAdelanto > meses {
                   print("Mes no válido")
                   print("Debe ingresar un mes entre 1 y \(meses)")
                   print("Ingrese nuevamente el mes:")

                   mesAdelanto = Int(readLine() ?? "0") ?? 0
               }
            print("Ingrese el monto adicional:")
               montoAdicional = Double(readLine() ?? "0") ?? 0

               while montoAdicional <= 0 {
                   print("Monto no válido")
                   print("El monto debe ser mayor que S/ 0.00")
                   print("Ingrese nuevamente el monto adicional:")

                   montoAdicional = Double(readLine() ?? "0") ?? 0
               }

               print("-------------------------")
               print("Mes del adelanto: \(mesAdelanto)")
               print("Monto adicional: S/ \(String(format: "%.2f", montoAdicional))")
            
    } else if respuestaAdelanto.uppercased() == "NO" {
        
        print("No se realizará adelanto de pago")
        
    } else{
        
        print("Debe ingresar SI o NO")
    }
    
    
    
    print("-------------------------")
    print("CALENDARIO DE PAGOS")
    print("-------------------------")
    
    var saldoRestante = montoFinal
    
    let calendario = Calendar.current
    let fechaActual = Date()
    
    let formatoFecha = DateFormatter()
    formatoFecha.dateFormat = "dd/MM/yyyy"
    var mesesPagados = 0
    
    print("Mes | Fecha       | Monto inicial | Adelanto    | Pago total   | Resta por pagar")
    print("-------------------------------------------------------------------------------")
    
    for mes in 1...meses {
        
        if saldoRestante <= 0 {
            break
        }
        
        let fechaPago = calendario.date(
            byAdding: .month,
            value: mes,
            to: fechaActual
        )!
        
        let montoInicial = saldoRestante
        
        var pago = cuotaMensual
        
        if mes == mesAdelanto {
            pago = pago + montoAdicional
        }
        
        if pago > saldoRestante {
            pago = saldoRestante
        }
        
        saldoRestante = saldoRestante - pago
        
        mesesPagados = mesesPagados + 1
        
        let fechaTexto = formatoFecha.string(from: fechaPago)
        
        var adelantoTexto = "S/ 0.00"
        
        if mes == mesAdelanto && montoAdicional > 0 {
            adelantoTexto = String(format: "S/ %.2f", montoAdicional)
        }
        
        let montoInicialTexto = String(format: "S/ %.2f", montoInicial)
        let pagoTexto = String(format: "S/ %.2f", pago)
        let saldoTexto = String(format: "S/ %.2f", saldoRestante)
        
        print(
            "\(mes) | \(fechaTexto) | \(montoInicialTexto) | \(adelantoTexto) | \(pagoTexto) | \(saldoTexto)"
        )
        
    }
    print("-------------------------")
    print("RESUMEN FINAL")
    print("-------------------------")
    print("Meses del plan original: \(meses)")
    print("Meses realmente pagados: \(mesesPagados)")
    print("Saldo final: S/ \(String(format: "%.2f", saldoRestante))")

    if mesesPagados < meses {
        print("Gracias al adelanto terminó de pagar antes.")
    } else {
        print("El plan se completó en los meses establecidos.")
    }
}


    

