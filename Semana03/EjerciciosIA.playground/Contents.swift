// Desarrollado por: Naomi Veliz
import Foundation // Permite utilizar funciones y tipos básicos de Foundation.

// ===== EJERCICIO 6: GESTIÓN DE NOTAS — CON IA =====

var notasAlumnos: [String: [Double]] = [:] // Crea el diccionario para guardar el nombre del alumno y sus tres notas.

print("¿Cuántos alumnos desea registrar?") // Solicita la cantidad de alumnos.
let cantidadAlumnos = Int(readLine() ?? "") ?? 0 // Convierte la cantidad ingresada a un número entero.

if cantidadAlumnos > 0 { // Verifica que se haya ingresado al menos un alumno.
    
    for i in 1...cantidadAlumnos { // Repite el registro según la cantidad de alumnos.
        print("\nAlumno \(i)") // Muestra el número del alumno que se está registrando.
        
        print("Nombre:") // Solicita el nombre del alumno.
        let nombre = readLine() ?? "" // Guarda el nombre ingresado.
        
        var notas: [Double] = [] // Crea un arreglo para guardar las tres notas del alumno.
        
        for j in 1...3 { // Repite el proceso tres veces para registrar las tres notas.
            print("Nota \(j):") // Solicita cada nota del alumno.
            let nota = Double(readLine() ?? "") ?? 0 // Convierte la nota ingresada a Double.
            notas.append(nota) // Agrega la nota al arreglo de notas.
        } // Finaliza el registro de las tres notas.
        
        notasAlumnos[nombre] = notas // Guarda el nombre y sus notas dentro del diccionario.
    } // Finaliza el registro de alumnos.
    
    var promedios: [String: Double] = [:] // Crea un diccionario para guardar el promedio de cada alumno.
    var sumaPromedios = 0.0 // Guarda la suma de todos los promedios.
    var notaMasAlta = 0.0 // Guarda la nota más alta encontrada.
    var notaMasBaja = 20.0 // Guarda la nota más baja encontrada.
    var cantidadAprobados = 0 // Cuenta cuántos alumnos aprobaron.
    
    print("\n===== RESULTADOS =====") // Muestra el encabezado del reporte.
    
    for (nombre, notas) in notasAlumnos { // Recorre cada alumno y sus notas.
        let promedio = notas.reduce(0, +) / Double(notas.count) // Calcula el promedio de las tres notas.
        promedios[nombre] = promedio // Guarda el promedio correspondiente al alumno.
        sumaPromedios += promedio // Acumula el promedio para calcular el promedio general.
        
        for nota in notas { // Recorre las notas para encontrar la mayor y la menor.
            if nota > notaMasAlta { // Comprueba si la nota actual es la más alta.
                notaMasAlta = nota // Actualiza la nota más alta.
            } // Finaliza la comprobación de la nota más alta.
            
            if nota < notaMasBaja { // Comprueba si la nota actual es la más baja.
                notaMasBaja = nota // Actualiza la nota más baja.
            } // Finaliza la comprobación de la nota más baja.
        } // Finaliza el recorrido de las notas.
        
        var clasificacion = "" // Crea una variable para guardar la clasificación del alumno.
        
        switch promedio { // Evalúa el promedio para determinar la clasificación.
        case 18...20: // Evalúa los promedios entre 18 y 20.
            clasificacion = "Excelente" // Asigna la clasificación Excelente.
        case 15..<18: // Evalúa los promedios desde 15 hasta menos de 18.
            clasificacion = "Bueno" // Asigna la clasificación Bueno.
        case 13..<15: // Evalúa los promedios desde 13 hasta menos de 15.
            clasificacion = "Aprobado" // Asigna la clasificación Aprobado.
        default: // Considera cualquier promedio menor a 13.
            clasificacion = "Desaprobado" // Asigna la clasificación Desaprobado.
        } // Finaliza la clasificación.
        
        if promedio >= 13 { // Verifica si el alumno aprobó.
            cantidadAprobados += 1 // Incrementa la cantidad de alumnos aprobados.
        } // Finaliza la verificación.
        
        print("\(nombre): Promedio \(String(format: "%.2f", promedio)) - \(clasificacion)") // Muestra el resultado del alumno.
    } // Finaliza el recorrido de alumnos.
    
    let promedioGeneral = sumaPromedios / Double(notasAlumnos.count) // Calcula el promedio general.
    let porcentajeAprobados = Double(cantidadAprobados) / Double(notasAlumnos.count) * 100 // Calcula el porcentaje de aprobados.
    
    print("\n===== ESTADÍSTICAS =====") // Muestra el encabezado de estadísticas.
    print("Promedio general: \(String(format: "%.2f", promedioGeneral))") // Muestra el promedio general.
    print("Nota más alta: \(notaMasAlta)") // Muestra la nota más alta.
    print("Nota más baja: \(notaMasBaja)") // Muestra la nota más baja.
    print("Porcentaje de aprobados: \(String(format: "%.2f", porcentajeAprobados))%") // Muestra el porcentaje de aprobados.
    
    let alumnosOrdenados = promedios.sorted { $0.value > $1.value } // Ordena los alumnos de mayor a menor promedio.
    
    print("\n===== ALUMNOS ORDENADOS POR PROMEDIO =====") // Muestra el encabezado del ranking.
    
    for (nombre, promedio) in alumnosOrdenados { // Recorre los alumnos ya ordenados.
        print("\(nombre): \(String(format: "%.2f", promedio))") // Muestra el nombre y promedio ordenados.
    } // Finaliza el recorrido de alumnos ordenados.
    
} else { // Se ejecuta cuando la cantidad ingresada no es válida.
    print("Debe ingresar una cantidad mayor a 0.") // Informa que debe ingresar al menos un alumno.
} // Finaliza la validación principal.


// ===== EJERCICIO 7: INVENTARIO CON MENÚ — CON IA =====
// Desarrollado por: Naomi Veliz
import Foundation
var preciosProductos: [String: Double] = [:] // Crea un diccionario para guardar el nombre y precio de cada producto.
var stockProductos: [String: Int] = [:] // Crea un diccionario para guardar el nombre y stock de cada producto.

print("\n¿Cuántos productos desea registrar?") // Pregunta al usuario cuántos productos desea ingresar.
let cantidadProductos = Int(readLine() ?? "") ?? 0 // Convierte la cantidad ingresada a un número entero.

if cantidadProductos > 0 { // Verifica que la cantidad de productos sea mayor a cero.
    
    for i in 1...cantidadProductos { // Repite el registro según la cantidad de productos indicada.
        
        print("\nProducto \(i)") // Muestra el número del producto que se está registrando.
        
        print("Nombre:") // Solicita el nombre del producto.
        let nombreProducto = readLine() ?? "" // Guarda el nombre ingresado por el usuario.
        
        print("Precio:") // Solicita el precio del producto.
        let precioProducto = Double(readLine() ?? "") ?? 0 // Convierte el precio ingresado a Double.
        
        print("Stock:") // Solicita la cantidad disponible del producto.
        let stockProducto = Int(readLine() ?? "") ?? 0 // Convierte el stock ingresado a un número entero.
        
        preciosProductos[nombreProducto] = precioProducto // Guarda el precio utilizando el nombre como clave.
        stockProductos[nombreProducto] = stockProducto // Guarda el stock utilizando el mismo nombre como clave.
        
    } // Finaliza el registro de productos.
    
    var opcion = 0 // Guarda la opción seleccionada por el usuario en el menú.
    
    while opcion != 5 { // Mantiene activo el menú hasta que el usuario seleccione la opción 5.
        
        print("\n===== MENÚ DE INVENTARIO =====") // Muestra el título principal del menú.
        print("1. Ver inventario") // Muestra la opción para visualizar todos los productos.
        print("2. Buscar producto") // Muestra la opción para buscar un producto.
        print("3. Productos con stock bajo") // Muestra la opción para consultar productos con poco stock.
        print("4. Valor total del inventario") // Muestra la opción para calcular el valor total.
        print("5. Salir") // Muestra la opción para finalizar el programa.
        print("Seleccione una opción:") // Solicita al usuario una opción del menú.
        
        opcion = Int(readLine() ?? "") ?? 0 // Convierte la opción ingresada a un número entero.
        
        switch opcion { // Evalúa la opción seleccionada por el usuario.
            
        case 1: // Ejecuta la opción para mostrar todo el inventario.
            
            print("\n===== INVENTARIO =====") // Muestra el encabezado del inventario.
            
            for (nombre, precio) in preciosProductos { // Recorre todos los productos almacenados.
                
                if let stock = stockProductos[nombre] { // Obtiene el stock correspondiente al producto.
                    print("\(nombre) | Precio: S/. \(String(format: "%.2f", precio)) | Stock: \(stock)") // Muestra nombre, precio y stock.
                } // Finaliza la validación del stock.
                
            } // Finaliza el recorrido del inventario.
            
        case 2: // Ejecuta la opción para buscar un producto.
            
            print("\nIngrese el nombre del producto que desea buscar:") // Solicita el nombre del producto.
            let productoBuscado = readLine() ?? "" // Guarda el nombre que desea buscar el usuario.
            
            if let precio = preciosProductos[productoBuscado], let stock = stockProductos[productoBuscado] { // Comprueba que el producto exista.
                print("\nProducto encontrado") // Informa que el producto fue encontrado.
                print("Nombre: \(productoBuscado)") // Muestra el nombre del producto.
                print("Precio: S/. \(String(format: "%.2f", precio))") // Muestra el precio del producto.
                print("Stock: \(stock)") // Muestra la cantidad disponible.
            } else { // Se ejecuta cuando el producto no existe.
                print("Producto no encontrado.") // Informa al usuario que no encontró el producto.
            } // Finaliza la búsqueda del producto.
            
        case 3: // Ejecuta la opción para mostrar productos con stock bajo.
            
            print("\n===== PRODUCTOS CON STOCK BAJO =====") // Muestra el encabezado del reporte.
            
            var existenProductosBajos = false // Indica si se encontró al menos un producto con stock bajo.
            
            for (nombre, stock) in stockProductos { // Recorre todos los productos y sus cantidades.
                
                if stock < 5 { // Comprueba si el producto tiene menos de cinco unidades.
                    print("\(nombre) | Stock: \(stock)") // Muestra el producto que tiene stock bajo.
                    existenProductosBajos = true // Indica que se encontró al menos un producto con stock bajo.
                } // Finaliza la comprobación del stock.
                
            } // Finaliza el recorrido de los productos.
            
            if existenProductosBajos == false { // Verifica si no se encontró ningún producto con stock bajo.
                print("No hay productos con stock bajo.") // Informa que todos los productos tienen suficiente stock.
            } // Finaliza la validación.
            
        case 4: // Ejecuta la opción para calcular el valor total del inventario.
            
            var valorTotalInventario = 0.0 // Inicializa el acumulador del valor total.
            
            for (nombre, precio) in preciosProductos { // Recorre cada producto y su precio.
                
                if let stock = stockProductos[nombre] { // Obtiene el stock correspondiente al producto.
                    valorTotalInventario += precio * Double(stock) // Multiplica precio por stock y acumula el resultado.
                } // Finaliza la validación del stock.
                
            } // Finaliza el cálculo de los productos.
            
            print("\n===== VALOR TOTAL DEL INVENTARIO =====") // Muestra el título del reporte.
            print("Valor total: S/. \(String(format: "%.2f", valorTotalInventario))") // Muestra el valor total con dos decimales.
            
        case 5: // Ejecuta la opción para terminar el programa.
            
            print("\nSaliendo del inventario...") // Informa al usuario que el programa finalizará.
            
        default: // Se ejecuta cuando se ingresa una opción distinta de 1 a 5.
            
            print("Opción inválida. Ingrese una opción del 1 al 5.") // Informa que la opción ingresada no es válida.
            
        } // Finaliza la evaluación de la opción.
        
    } // Finaliza el ciclo del menú cuando se selecciona la opción 5.
    
} else { // Se ejecuta cuando la cantidad de productos es cero o menor.
    
    print("Debe ingresar una cantidad mayor a 0.") // Informa que debe registrar al menos un producto.
    
} // Finaliza la validación principal.
