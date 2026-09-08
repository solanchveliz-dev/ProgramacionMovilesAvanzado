import Foundation

// METROGUÍA LIMA
// COMMIT 1: Registro, búsqueda y exploración de líneas y estaciones.

let linea1 = [
    "Bayóvar", "Santa Rosa", "San Martín", "San Carlos", "Los Postes",
    "Los Jardines", "Pirámide del Sol", "Caja de Agua", "Presbítero Maestro",
    "El Ángel", "Miguel Grau", "Gamarra", "Nicolás Arriola", "La Cultura",
    "San Borja Sur", "Angamos", "Cabitos", "Ayacucho", "Jorge Chávez",
    "Atocongo", "San Juan", "María Auxiliadora", "Villa María", "Pumacahua",
    "Parque Industrial", "Villa El Salvador"
]

let linea2 = [
    "Puerto del Callao", "Buenos Aires", "Juan Pablo II", "Insurgentes",
    "Carmen de la Legua", "Óscar R. Benavides", "San Marcos", "Elio",
    "La Alborada", "Tingo María", "Parque Murillo", "Plaza Bolognesi",
    "Estación Central", "Plaza Manco Cápac", "Cangallo", "28 de Julio",
    "Nicolás Ayllón", "Circunvalación", "San Juan de Dios", "Evitamiento",
    "Óvalo Santa Anita", "Colectora Industrial", "Hermilio Valdizán",
    "Mercado Santa Anita", "Vista Alegre", "Prolongación Javier Prado",
    "Municipalidad de Ate"
]

let linea3 = [
    "El Álamo", "Huandoy", "2 de Octubre", "Villa Sol", "Naranjal",
    "Carlos Izaguirre", "Tomás Valle", "Bartolomé de las Casas", "José Granda",
    "Caquetá", "Tacna", "Garcilaso de la Vega", "Estación Central",
    "Parque de la Reserva", "Museo de Historia Natural", "César Canevaro",
    "Conde de San Isidro", "Andrés Aramburú", "Huaca Pucllana",
    "Parque Central de Miraflores", "Parque Reducto", "República de Panamá",
    "Juana Alarco", "Cabitos", "Alejandro Velasco", "Las Gardenias",
    "Los Héroes", "Pedro Miotta"
]

let linea4 = [
    "Gambetta", "Canta Callao", "Bocanegra", "Aeropuerto", "El Olivar",
    "Quilca", "Morales Duárez", "Carmen de la Legua", "Venezuela",
    "Rafael Escardó", "Pando", "José de Sucre", "Brasil", "Felipe Salaverry",
    "Guillermo Prescott", "Las Palmeras", "Conde de San Isidro",
    "Rivera Navarrete", "Pablo Carriquiry", "La Cultura", "San Luis",
    "Monterrico", "Manuel Olguín", "Los Frutales", "La Molina",
    "Santa Patricia", "Mayorazgo", "Mercado Santa Anita"
]

let lineas: [String: [String]] = [
    "1": linea1,
    "2": linea2,
    "3": linea3,
    "4": linea4
]

func normalizarTexto(_ texto: String) -> String {
    return texto
        .lowercased()
        .folding(options: .diacriticInsensitive, locale: Locale.current)
        .trimmingCharacters(in: .whitespacesAndNewlines)
}

func obtenerLineasDeEstacion(_ nombre: String) -> [String] {
    let nombreNormalizado = normalizarTexto(nombre)
    var lineasEncontradas: [String] = []

    for numeroLinea in ["1", "2", "3", "4"] {
        if let estaciones = lineas[numeroLinea] {
            for estacion in estaciones {
                if normalizarTexto(estacion) == nombreNormalizado {
                    lineasEncontradas.append(numeroLinea)
                }
            }
        }
    }

    return lineasEncontradas
}

func obtenerNombreCorrecto(_ nombre: String) -> String? {
    let nombreNormalizado = normalizarTexto(nombre)

    for numeroLinea in ["1", "2", "3", "4"] {
        if let estaciones = lineas[numeroLinea] {
            for estacion in estaciones {
                if normalizarTexto(estacion) == nombreNormalizado {
                    return estacion
                }
            }
        }
    }

    return nil
}

func mostrarLinea(_ numeroLinea: String) {
    if let estaciones = lineas[numeroLinea] {
        print("\n================================")
        print("             LÍNEA \(numeroLinea)")
        print("================================")
        print("Primera estación: \(estaciones[0])")
        print("Última estación: \(estaciones[estaciones.count - 1])")
        print("Cantidad de estaciones: \(estaciones.count)\n")

        for posicion in 0..<estaciones.count {
            print("\(posicion + 1). \(estaciones[posicion])")
        }
    } else {
        print("La línea seleccionada no existe.")
    }
}

func explorarLineas() {
    var opcionLinea = 0

    while opcionLinea != 6 {
        print("\n================================")
        print("       EXPLORAR LAS LÍNEAS")
        print("================================")
        print("1. Línea 1")
        print("2. Línea 2")
        print("3. Línea 3")
        print("4. Línea 4")
        print("5. Ver todas las líneas")
        print("6. Volver al menú principal")
        print("Selecciona una opción:")

        let entrada = readLine() ?? ""
        opcionLinea = Int(entrada) ?? 0

        if opcionLinea >= 1 && opcionLinea <= 4 {
            mostrarLinea(String(opcionLinea))
        } else if opcionLinea == 5 {
            for numeroLinea in ["1", "2", "3", "4"] {
                mostrarLinea(numeroLinea)
            }
        } else if opcionLinea == 6 {
            print("Regresando al menú principal...")
        } else {
            print("Opción incorrecta. Ingresa un número del 1 al 6.")
        }
    }
}

func buscarEstacion() {
    print("\n================================")
    print("          BUSCAR ESTACIÓN")
    print("================================")
    print("Escribe el nombre de la estación:")

    let nombreIngresado = readLine() ?? ""

    if let nombreCorrecto = obtenerNombreCorrecto(nombreIngresado) {
        let lineasEncontradas = obtenerLineasDeEstacion(nombreCorrecto)

        print("\nEstación encontrada: \(nombreCorrecto)")

        if lineasEncontradas.count == 1 {
            print("Pertenece a la Línea \(lineasEncontradas[0]).")
        } else {
            print("Esta estación conecta las siguientes líneas:")

            for linea in lineasEncontradas {
                print("- Línea \(linea)")
            }
        }
    } else {
        print("No se encontró la estación ingresada.")
        print("Verifica el nombre e intenta nuevamente.")
    }
}

var opcionPrincipal = 0

while opcionPrincipal != 3 {
    print("\n================================")
    print("        METROGUÍA LIMA")
    print("================================")
    print("1. Explorar líneas y estaciones")
    print("2. Buscar una estación")
    print("3. Salir")
    print("Selecciona una opción:")

    let entrada = readLine() ?? ""
    opcionPrincipal = Int(entrada) ?? 0

    if opcionPrincipal == 1 {
        explorarLineas()
    } else if opcionPrincipal == 2 {
        buscarEstacion()
    } else if opcionPrincipal == 3 {
        print("Gracias por utilizar MetroGuía Lima.")
    } else {
        print("Opción incorrecta. Ingresa un número del 1 al 3.")
    }
}
