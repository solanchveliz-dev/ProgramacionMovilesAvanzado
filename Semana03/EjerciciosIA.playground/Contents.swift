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
