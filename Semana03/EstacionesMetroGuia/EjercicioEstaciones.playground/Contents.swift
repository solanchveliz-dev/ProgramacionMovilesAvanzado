import Foundation

// METROGUÍA LIMA

// COMMIT 4: Búsqueda de lugares y recomendación de estaciones.

// Primera versión para ejecutarse mediante la consola de la Mac.

// REQUERIMIENTOS FUNCIONALES IMPLEMENTADOS

// RF01: Mostrar el menú principal.

// RF02: Almacenar las estaciones de las líneas 1, 2, 3 y 4.

// RF03: Aceptar nombres con o sin tildes y mayúsculas.

// RF04: Explorar líneas, estaciones, horarios y tarifas.

// RF05: Identificar las líneas a las que pertenece una estación.

// RF06: Calcular rutas directas dentro de una misma línea.

// RF07: Indicar la dirección correcta del tren.

// RF08: Calcular rutas con cambio de línea.

// RF09: Utilizar las estaciones oficiales de conexión.

// RF10: Seleccionar la conexión que recorra menos estaciones.

// RF11: Calcular el tiempo aproximado del recorrido.

// RF12: Buscar un lugar por su nombre.

// RF13: Mostrar coincidencias cuando varios lugares se parecen.

// RF14: Buscar lugares por categoría.

// RF15: Recomendar una estación para llegar a un lugar.

// RF16: Mostrar lugares relacionados con una estación.

// RF17: Mostrar la dirección del lugar seleccionado.

// RF18: Finalizar el programa cuando el usuario seleccione salir.

// RF19: Mostrar juntos los horarios y tarifas de todas las líneas.

// ================================================================

// RF02: COLECCIONES DE LÍNEAS Y ESTACIONES

// ================================================================

let linea1 = [

    "Bayóvar", "Santa Rosa", "San Martín", "San Carlos", "Los Postes",

    "Los Jardines", "Pirámide del Sol", "Caja de Agua", "Presbítero Maestro",

    "El Ángel", "Miguel Grau", "28 de Julio", "Gamarra", "Nicolás Arriola", "La Cultura",

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

// ================================================================

// RF09 Y RF10: CONEXIONES ENTRE LÍNEAS

// ================================================================

// Conexiones proyectadas entre las líneas del Metro de Lima y Callao.

// Se usa un arreglo porque las líneas 2 y 4 tienen dos conexiones posibles.

let conexiones: [String: [String]] = [

    "1-2": ["28 de Julio"],

    "2-1": ["28 de Julio"],

    "1-3": ["Cabitos"],

    "3-1": ["Cabitos"],

    "1-4": ["La Cultura"],

    "4-1": ["La Cultura"],

    "2-3": ["Estación Central"],

    "3-2": ["Estación Central"],

    "2-4": ["Carmen de la Legua", "Mercado Santa Anita"],

    "4-2": ["Carmen de la Legua", "Mercado Santa Anita"],

    "3-4": ["Conde de San Isidro"],

    "4-3": ["Conde de San Isidro"]

]

// ================================================================

// RF04: HORARIOS Y TARIFAS REFERENCIALES

// ================================================================

// La información puede cambiar y debe actualizarse con fuentes oficiales.

// Las líneas 3 y 4 todavía no tienen horario ni tarifa definidos.

let horarioPorLinea: [String: String] = [

    "1": "Lunes a sábado: 5:00 a. m. a 10:00 p. m. | Domingos y feriados: 5:30 a. m. a 10:00 p. m.",

    "2": "Todos los días: 6:00 a. m. a 11:00 p. m.",

    "3": "Horario por definir para su futura operación.",

    "4": "Horario por definir para su futura operación."

]

let tarifaGeneralPorLinea: [String: String] = [

    "1": "S/1.50",

    "2": "S/1.40",

    "3": "Tarifa por definir",

    "4": "Tarifa por definir"

]

let tarifaPreferencialPorLinea: [String: String] = [

    "1": "S/0.75 para escolares y universitarios",

    "2": "S/0.70 para escolares y universitarios",

    "3": "Tarifa por definir",

    "4": "Tarifa por definir"

]

let costoTarjetaPorLinea: [String: String] = [

    "1": "Consultar el costo vigente de la tarjeta en Línea 1",

    "2": "S/7.50 por la Tarjeta Interoperable de Transporte",

    "3": "Sistema de pago por definir",

    "4": "Sistema de pago por definir"

]

let fechaActualizacionServicio = "setiembre de 2026"

// ================================================================

// RF12 AL RF17: INFORMACIÓN DE LUGARES

// ================================================================

// Cada lugar está relacionado con la estación recomendada para llegar.

let estacionDelLugar: [String: String] = [

    "Aeropuerto Internacional Jorge Chávez": "Aeropuerto",

    "Biblioteca Nacional del Perú": "La Cultura",

    "Emporio Comercial de Gamarra": "Gamarra",

    "Fortaleza del Real Felipe": "Puerto del Callao",

    "Gran Teatro Nacional": "La Cultura",

    "Hospital Guillermo Almenara": "Miguel Grau",

    "Hospital Nacional Dos de Mayo": "Miguel Grau",

    "Instituto Tecsup - Sede Lima": "Mercado Santa Anita",

    "Jockey Plaza": "Manuel Olguín",

    "Larcomar": "Parque Central de Miraflores",

    "Mall del Sur": "Los Héroes",

    "MegaPlaza": "Carlos Izaguirre",

    "Ministerio de Cultura": "La Cultura",

    "Museo de la Nación": "La Cultura",

    "Parque Cánepa": "Gamarra",

    "Parque del Amor": "Parque Central de Miraflores",

    "Parque Kennedy": "Parque Central de Miraflores",

    "Plaza Norte": "Tomás Valle",

    "Real Plaza Centro Cívico": "Estación Central",

    "Universidad Nacional Mayor de San Marcos": "San Marcos"

]

let categoriaDelLugar: [String: String] = [

    "Aeropuerto Internacional Jorge Chávez": "Aeropuerto",

    "Biblioteca Nacional del Perú": "Biblioteca",

    "Emporio Comercial de Gamarra": "Zona comercial",

    "Fortaleza del Real Felipe": "Lugar histórico",

    "Gran Teatro Nacional": "Centro cultural",

    "Hospital Guillermo Almenara": "Hospital",

    "Hospital Nacional Dos de Mayo": "Hospital",

    "Instituto Tecsup - Sede Lima": "Instituto",

    "Jockey Plaza": "Centro comercial",

    "Larcomar": "Centro comercial",

    "Mall del Sur": "Centro comercial",

    "MegaPlaza": "Centro comercial",

    "Ministerio de Cultura": "Entidad pública",

    "Museo de la Nación": "Museo",

    "Parque Cánepa": "Parque",

    "Parque del Amor": "Parque",

    "Parque Kennedy": "Parque",

    "Plaza Norte": "Centro comercial",

    "Real Plaza Centro Cívico": "Centro comercial",

    "Universidad Nacional Mayor de San Marcos": "Universidad"

]

let direccionDelLugar: [String: String] = [

    "Aeropuerto Internacional Jorge Chávez": "Av. Morales Duárez, Callao",

    "Biblioteca Nacional del Perú": "Av. De la Poesía 160, San Borja",

    "Emporio Comercial de Gamarra": "Jr. Agustín Gamarra, La Victoria",

    "Fortaleza del Real Felipe": "Plaza Independencia, Callao",

    "Gran Teatro Nacional": "Av. Javier Prado Este 2225, San Borja",

    "Hospital Guillermo Almenara": "Av. Grau 800, La Victoria",

    "Hospital Nacional Dos de Mayo": "Av. Grau 1300, Cercado de Lima",

    "Instituto Tecsup - Sede Lima": "Av. Cascanueces 2221, Santa Anita",

    "Jockey Plaza": "Av. Javier Prado Este 4200, Santiago de Surco",

    "Larcomar": "Malecón de la Reserva 610, Miraflores",

    "Mall del Sur": "Av. Los Lirios 301, San Juan de Miraflores",

    "MegaPlaza": "Av. Alfredo Mendiola 3698, Independencia",

    "Ministerio de Cultura": "Av. Javier Prado Este 2465, San Borja",

    "Museo de la Nación": "Av. Javier Prado Este 2465, San Borja",

    "Parque Cánepa": "Jr. Huánuco, La Victoria",

    "Parque del Amor": "Malecón Cisneros, Miraflores",

    "Parque Kennedy": "Av. Diagonal, Miraflores",

    "Plaza Norte": "Av. Alfredo Mendiola 1400, Independencia",

    "Real Plaza Centro Cívico": "Av. Garcilaso de la Vega 1337, Cercado de Lima",

    "Universidad Nacional Mayor de San Marcos": "Av. Carlos Germán Amezaga 375, Cercado de Lima"

]

// ================================================================

// RF03: NORMALIZACIÓN Y VALIDACIÓN DE NOMBRES

// ================================================================

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

func obtenerLugarCorrecto(_ nombre: String) -> String? {

    let nombreNormalizado = normalizarTexto(nombre)

    for lugar in estacionDelLugar.keys {

        if normalizarTexto(lugar) == nombreNormalizado {

            return lugar

        }

    }

    return nil

}

func convertirLineasATexto(_ numeros: [String]) -> String {

    var nombres: [String] = []

    for numero in numeros {

        nombres.append("Línea \(numero)")

    }

    return nombres.joined(separator: " y ")

}

// ================================================================

// RF04 Y RF05: EXPLORACIÓN DE LÍNEAS E INFORMACIÓN DEL SERVICIO

// ================================================================

func mostrarLinea(_ numeroLinea: String) {

    if let estaciones = lineas[numeroLinea] {

        print("\n================================")

        print("             LÍNEA \(numeroLinea)")

        print("================================")

        print("Primera estación: \(estaciones[0])")

        print("Última estación: \(estaciones[estaciones.count - 1])")

        print("Cantidad de estaciones: \(estaciones.count)\n")

        print("INFORMACIÓN DEL SERVICIO")

        print("Horario: \(horarioPorLinea[numeroLinea] ?? "Por definir")")

        print("Tarifa general: \(tarifaGeneralPorLinea[numeroLinea] ?? "Por definir")")

        print("Tarifa preferencial: \(tarifaPreferencialPorLinea[numeroLinea] ?? "Por definir")")

        print("Tarjeta: \(costoTarjetaPorLinea[numeroLinea] ?? "Por definir")")

        print("Datos consultados en: \(fechaActualizacionServicio)")

        print("La información puede cambiar. Verifica los canales oficiales.\n")

        print("ESTACIONES")

        for posicion in 0..<estaciones.count {

            print("\(posicion + 1). \(estaciones[posicion])")

        }

        print("\nCONEXIONES DISPONIBLES")

        var encontroConexion = false

        for estacion in estaciones {

            let lineasDeLaEstacion = obtenerLineasDeEstacion(estacion)

            if lineasDeLaEstacion.count > 1 {

                var otrasLineas: [String] = []

                for lineaEncontrada in lineasDeLaEstacion {

                    if lineaEncontrada != numeroLinea {

                        otrasLineas.append(lineaEncontrada)

                    }

                }

                print("- \(estacion): conexión con \(convertirLineasATexto(otrasLineas))")

                encontroConexion = true

            }

        }

        if !encontroConexion {

            print("Esta línea no tiene conexiones registradas.")

        }

    } else {

        print("La línea seleccionada no existe.")

    }

}

func mostrarHorariosYTarifas() {

    print("\n================================")

    print("       HORARIOS Y TARIFAS")

    print("================================")

    for numeroLinea in ["1", "2", "3", "4"] {

        let horario = horarioPorLinea[numeroLinea] ?? "Por definir"

        let tarifaGeneral = tarifaGeneralPorLinea[numeroLinea] ?? "Por definir"

        let tarifaPreferencial = tarifaPreferencialPorLinea[numeroLinea] ?? "Por definir"

        let costoTarjeta = costoTarjetaPorLinea[numeroLinea] ?? "Por definir"

        print("\nLÍNEA \(numeroLinea)")

        print("Horario: \(horario)")

        print("Tarifa general: \(tarifaGeneral)")

        print("Tarifa preferencial: \(tarifaPreferencial)")

        print("Tarjeta: \(costoTarjeta)")

    }

    print("\nDatos consultados en: \(fechaActualizacionServicio)")

    print("La información puede cambiar. Verifica los canales oficiales.")

}

func explorarLineas() {

    var opcionLinea = 0

    while opcionLinea != 7 {

        print("\n================================")

        print("       EXPLORAR LAS LÍNEAS")

        print("================================")

        print("1. Línea 1")

        print("2. Línea 2")

        print("3. Línea 3")

        print("4. Línea 4")

        print("5. Ver todas las líneas")

        print("6. Ver horarios y tarifas")

        print("7. Volver al menú principal")

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

            mostrarHorariosYTarifas()

        } else if opcionLinea == 7 {

            print("Regresando al menú principal...")

        } else {

            print("Opción incorrecta. Ingresa un número del 1 al 7.")

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

// ================================================================

// RF06 AL RF11: CÁLCULO DE RUTAS, DIRECCIÓN, CONEXIONES Y TIEMPO

// ================================================================

func buscarLineaCompartida(origen: String, destino: String) -> String? {

    let lineasOrigen = obtenerLineasDeEstacion(origen)

    let lineasDestino = obtenerLineasDeEstacion(destino)

    for lineaOrigen in lineasOrigen {

        if lineasDestino.contains(lineaOrigen) {

            return lineaOrigen

        }

    }

    return nil

}

func calcularCantidadEstaciones(

    linea: String,

    origen: String,

    destino: String

) -> Int? {

    guard let estaciones = lineas[linea],

          let posicionOrigen = estaciones.firstIndex(of: origen),

          let posicionDestino = estaciones.firstIndex(of: destino) else {

        return nil

    }

    return abs(posicionDestino - posicionOrigen)

}

func mostrarTramo(linea: String, origen: String, destino: String) {

    guard let estaciones = lineas[linea],

          let posicionOrigen = estaciones.firstIndex(of: origen),

          let posicionDestino = estaciones.firstIndex(of: destino) else {

        print("No se pudo mostrar este tramo.")

        return

    }

    if posicionOrigen == posicionDestino {

        print("Ya te encuentras en \(origen).")

        return

    }

    print("Aborda la Línea \(linea) en \(origen).")

    if posicionOrigen < posicionDestino {

        print("Toma el tren en dirección a \(estaciones[estaciones.count - 1]).")

        print("Estaciones de este tramo:")

        for posicion in posicionOrigen...posicionDestino {

            print("  \(posicion - posicionOrigen + 1). \(estaciones[posicion])")

        }

    } else {

        print("Toma el tren en dirección a \(estaciones[0]).")

        print("Estaciones de este tramo:")

        var numero = 1

        for posicion in stride(from: posicionOrigen, through: posicionDestino, by: -1) {

            print("  \(numero). \(estaciones[posicion])")

            numero += 1

        }

    }

    print("Baja en \(destino).")

}

func mostrarRutaDirecta(origen: String, destino: String, linea: String) {

    guard let estaciones = lineas[linea],

          let posicionOrigen = estaciones.firstIndex(of: origen),

          let posicionDestino = estaciones.firstIndex(of: destino) else {

        print("No se pudo calcular la ruta.")

        return

    }

    if posicionOrigen == posicionDestino {

        print("Ya te encuentras en la estación \(origen).")

        return

    }

    let cantidadEstaciones = abs(posicionDestino - posicionOrigen)

    let tiempoAproximado = cantidadEstaciones * 2

    print("\n================================")

    print("        RUTA ENTRE ESTACIONES")

    print("================================")

    print("Origen: \(origen)")

    print("Destino: \(destino)")

    print("Línea: Línea \(linea)\n")

    print("Aborda la Línea \(linea) en \(origen).")

    if posicionOrigen < posicionDestino {

        print("Sube al tren que va hacia \(estaciones[estaciones.count - 1]).")

        print("\nEstaciones del recorrido:")

        for posicion in posicionOrigen...posicionDestino {

            print("\(posicion - posicionOrigen + 1). \(estaciones[posicion])")

        }

    } else {

        print("Sube al tren que va hacia \(estaciones[0]).")

        print("\nEstaciones del recorrido:")

        var numero = 1

        for posicion in stride(from: posicionOrigen, through: posicionDestino, by: -1) {

            print("\(numero). \(estaciones[posicion])")

            numero += 1

        }

    }

    print("\nBaja en \(destino).")

    print("No necesitas cambiar de línea.")

    print("Estaciones recorridas: \(cantidadEstaciones)")

    print("Tiempo aproximado: \(tiempoAproximado) minutos")

    print("El tiempo puede variar según la espera y el servicio.")

}

func viajarEntreEstaciones(

    origenSugerido: String? = nil,

    destinoSugerido: String? = nil

) {

    print("\n================================")

    print("     VIAJAR HACIA OTRA ESTACIÓN")

    print("================================")

    var origenIngresado = ""

    if let estacionOrigen = origenSugerido {

        origenIngresado = estacionOrigen

    } else {

        print("¿En qué estación te encuentras?")

        origenIngresado = readLine() ?? ""

    }

    var destinoIngresado = ""

    if let estacionSugerida = destinoSugerido {

        destinoIngresado = estacionSugerida

        print("Estación de destino recomendada: \(estacionSugerida)")

    } else {

        print("¿A qué estación quieres llegar?")

        destinoIngresado = readLine() ?? ""

    }

    guard let origen = obtenerNombreCorrecto(origenIngresado) else {

        print("No se encontró la estación de origen.")

        return

    }

    guard let destino = obtenerNombreCorrecto(destinoIngresado) else {

        print("No se encontró la estación de destino.")

        return

    }

    if origen == destino {

        print("Ya te encuentras en la estación \(origen).")

    } else if let lineaCompartida = buscarLineaCompartida(origen: origen, destino: destino) {

        mostrarRutaDirecta(origen: origen, destino: destino, linea: lineaCompartida)

    } else {

        let lineasOrigen = obtenerLineasDeEstacion(origen)

        let lineasDestino = obtenerLineasDeEstacion(destino)

        var mejorLineaOrigen = ""

        var mejorLineaDestino = ""

        var mejorLineaIntermedia = ""

        var mejorConexion = ""

        var segundaConexion = ""

        var menorCantidad = Int.max

        for lineaOrigen in lineasOrigen {

            for lineaDestino in lineasDestino {

                let clave = "\(lineaOrigen)-\(lineaDestino)"

                if let estacionesConexion = conexiones[clave] {

                    for estacionConexion in estacionesConexion {

                        if let primerTramo = calcularCantidadEstaciones(

                            linea: lineaOrigen,

                            origen: origen,

                            destino: estacionConexion

                        ), let segundoTramo = calcularCantidadEstaciones(

                            linea: lineaDestino,

                            origen: estacionConexion,

                            destino: destino

                        ) {

                            let cantidadTotal = primerTramo + segundoTramo

                            if cantidadTotal < menorCantidad {

                                menorCantidad = cantidadTotal

                                mejorLineaOrigen = lineaOrigen

                                mejorLineaDestino = lineaDestino

                                mejorConexion = estacionConexion

                            }

                        }

                    }

                }

            }

        }

        // La Línea 1 y la Línea 2 no tienen conexión directa.

        // En ese caso se busca una ruta usando la Línea 3 o la Línea 4.

        if mejorConexion.isEmpty {

            for lineaOrigen in lineasOrigen {

                for lineaDestino in lineasDestino {

                    for lineaIntermedia in ["3", "4"] {

                        let primeraClave = "\(lineaOrigen)-\(lineaIntermedia)"

                        let segundaClave = "\(lineaIntermedia)-\(lineaDestino)"

                        if let primerasConexiones = conexiones[primeraClave],

                           let segundasConexiones = conexiones[segundaClave] {

                            for primeraEstacion in primerasConexiones {

                                for segundaEstacion in segundasConexiones {

                                    if let primerTramo = calcularCantidadEstaciones(

                                        linea: lineaOrigen,

                                        origen: origen,

                                        destino: primeraEstacion

                                    ), let tramoIntermedio = calcularCantidadEstaciones(

                                        linea: lineaIntermedia,

                                        origen: primeraEstacion,

                                        destino: segundaEstacion

                                    ), let ultimoTramo = calcularCantidadEstaciones(

                                        linea: lineaDestino,

                                        origen: segundaEstacion,

                                        destino: destino

                                    ) {

                                        let cantidadTotal = primerTramo

                                            + tramoIntermedio

                                            + ultimoTramo

                                        if cantidadTotal < menorCantidad {

                                            menorCantidad = cantidadTotal

                                            mejorLineaOrigen = lineaOrigen

                                            mejorLineaDestino = lineaDestino

                                            mejorLineaIntermedia = lineaIntermedia

                                            mejorConexion = primeraEstacion

                                            segundaConexion = segundaEstacion

                                        }

                                    }

                                }

                            }

                        }

                    }

                }

            }

        }

        if mejorConexion.isEmpty {

            print("No se encontró una conexión para esta ruta.")

            return

        }

        var cantidadCambios = 1

        if !segundaConexion.isEmpty {

            cantidadCambios = 2

        }

        let tiempoAproximado = menorCantidad * 2 + cantidadCambios * 5

        print("\n================================")

        print("       RUTA CON CAMBIO DE LÍNEA")

        print("================================")

        print("Origen: \(origen)")

        print("Destino: \(destino)\n")

        print("PRIMER TRAMO")

        mostrarTramo(

            linea: mejorLineaOrigen,

            origen: origen,

            destino: mejorConexion

        )

        print("\nCAMBIO DE LÍNEA")

        print("En \(mejorConexion), sigue las señales para cambiar")

        if segundaConexion.isEmpty {

            print("de la Línea \(mejorLineaOrigen) a la Línea \(mejorLineaDestino).")

            print("\nSEGUNDO TRAMO")

            mostrarTramo(

                linea: mejorLineaDestino,

                origen: mejorConexion,

                destino: destino

            )

        } else {

            print("de la Línea \(mejorLineaOrigen) a la Línea \(mejorLineaIntermedia).")

            print("\nSEGUNDO TRAMO")

            mostrarTramo(

                linea: mejorLineaIntermedia,

                origen: mejorConexion,

                destino: segundaConexion

            )

            print("\nSEGUNDO CAMBIO DE LÍNEA")

            print("En \(segundaConexion), sigue las señales para cambiar")

            print("de la Línea \(mejorLineaIntermedia) a la Línea \(mejorLineaDestino).")

            print("\nTERCER TRAMO")

            mostrarTramo(

                linea: mejorLineaDestino,

                origen: segundaConexion,

                destino: destino

            )

        }

        print("\nRESUMEN DEL VIAJE")

        if segundaConexion.isEmpty {

            print("Cambio de línea: \(mejorConexion)")

        } else {

            print("Cambios de línea: \(mejorConexion) y \(segundaConexion)")

        }

        print("Estaciones recorridas: \(menorCantidad)")

        print("Tiempo aproximado: \(tiempoAproximado) minutos")

        print("Incluye 5 minutos aproximados por cada cambio de línea.")

        print("El tiempo puede variar según la espera y el servicio.")

    }

}

// ================================================================

// RF12 AL RF17: BÚSQUEDA Y RECOMENDACIÓN DE LUGARES

// ================================================================

func elegirLugarDeLista(_ lugares: [String]) -> String? {

    if lugares.isEmpty {

        print("No hay lugares registrados en esta búsqueda.")

        return nil

    }

    for posicion in 0..<lugares.count {

        let lugar = lugares[posicion]

        let estacion = estacionDelLugar[lugar] ?? "Sin estación"

        print("\(posicion + 1). \(lugar)")

        print("   Estación recomendada: \(estacion)")

    }

    print("Selecciona el número del lugar:")

    let opcion = Int(readLine() ?? "") ?? 0

    if opcion >= 1 && opcion <= lugares.count {

        return lugares[opcion - 1]

    }

    print("Selección incorrecta.")

    return nil

}

func buscarLugarPorNombre() -> String? {

    print("Escribe el lugar al que quieres ir:")

    let textoIngresado = normalizarTexto(readLine() ?? "")

    var coincidencias: [String] = []

    for lugar in estacionDelLugar.keys {

        let lugarNormalizado = normalizarTexto(lugar)

        if lugarNormalizado.contains(textoIngresado) && !textoIngresado.isEmpty {

            coincidencias.append(lugar)

        }

    }

    coincidencias.sort()

    if coincidencias.count == 1 {

        return coincidencias[0]

    } else if coincidencias.count > 1 {

        print("\nSe encontraron varias coincidencias:")

        return elegirLugarDeLista(coincidencias)

    }

    print("El lugar todavía no está registrado.")

    return nil

}

func buscarLugarPorCategoria() -> String? {

    print("\nCATEGORÍAS")

    print("1. Hospitales")

    print("2. Centros comerciales")

    print("3. Parques")

    print("4. Universidades e institutos")

    print("5. Museos y cultura")

    print("6. Lugares turísticos")

    print("7. Entidades públicas")

    print("Selecciona una categoría:")

    let opcion = Int(readLine() ?? "") ?? 0

    var lugaresEncontrados: [String] = []

    for lugar in estacionDelLugar.keys {

        let categoria = categoriaDelLugar[lugar] ?? ""

        var pertenece = false

        if opcion == 1 && categoria == "Hospital" {

            pertenece = true

        } else if opcion == 2 && categoria == "Centro comercial" {

            pertenece = true

        } else if opcion == 3 && categoria == "Parque" {

            pertenece = true

        } else if opcion == 4 &&

                    (categoria == "Universidad" || categoria == "Instituto") {

            pertenece = true

        } else if opcion == 5 &&

                    (categoria == "Museo" || categoria == "Biblioteca" ||

                     categoria == "Centro cultural") {

            pertenece = true

        } else if opcion == 6 && categoria == "Lugar histórico" {

            pertenece = true

        } else if opcion == 7 && categoria == "Entidad pública" {

            pertenece = true

        }

        if pertenece {

            lugaresEncontrados.append(lugar)

        }

    }

    if opcion < 1 || opcion > 7 {

        print("Categoría incorrecta.")

        return nil

    }

    lugaresEncontrados.sort()

    return elegirLugarDeLista(lugaresEncontrados)

}

func mostrarDestinoFinal(_ lugar: String, estacion: String) {

    let direccion = direccionDelLugar[lugar] ?? "Dirección por validar"

    print("\n================================")

    print("          DESTINO FINAL")

    print("================================")

    print("Desde \(estacion) continúa hacia \(lugar).")

    print("Dirección: \(direccion)")

    print("Tiempo adicional hasta el lugar: por validar")

    print("Puedes escribir la dirección en tu aplicación de mapas")

    print("para completar el recorrido desde la estación.")

}

func saberComoLlegarAUnLugar() {

    print("\n================================")

    print("       BUSCAR UN DESTINO")

    print("================================")

    print("¿En qué estación te encuentras?")

    let origenIngresado = readLine() ?? ""

    guard let origen = obtenerNombreCorrecto(origenIngresado) else {

        print("No se encontró la estación de origen.")

        return

    }

    let lineasOrigen = obtenerLineasDeEstacion(origen)

    print("\nEstación encontrada: \(origen)")

    print("Línea: \(convertirLineasATexto(lineasOrigen))")

    print("\n¿CÓMO DESEAS BUSCAR EL LUGAR?")

    print("1. Escribir el nombre")

    print("2. Buscar por categoría")

    print("3. Volver al menú principal")

    print("Selecciona una opción:")

    let opcion = Int(readLine() ?? "") ?? 0

    var lugarSeleccionado: String? = nil

    if opcion == 1 {

        lugarSeleccionado = buscarLugarPorNombre()

    } else if opcion == 2 {

        lugarSeleccionado = buscarLugarPorCategoria()

    } else if opcion == 3 {

        print("Regresando al menú principal...")

        return

    } else {

        print("Opción incorrecta.")

        return

    }

    guard let lugar = lugarSeleccionado,

          let estacionDestino = estacionDelLugar[lugar] else {

        return

    }

    let categoria = categoriaDelLugar[lugar] ?? "Sin categoría"

    let direccion = direccionDelLugar[lugar] ?? "Dirección por validar"

    let lineasDestino = obtenerLineasDeEstacion(estacionDestino)

    print("\nLugar encontrado: \(lugar)")

    print("Categoría: \(categoria)")

    print("Dirección: \(direccion)")

    print("Estación recomendada: \(estacionDestino)")

    print("Línea del destino: \(convertirLineasATexto(lineasDestino))")

    viajarEntreEstaciones(

        origenSugerido: origen,

        destinoSugerido: estacionDestino

    )

    mostrarDestinoFinal(lugar, estacion: estacionDestino)

}

func verLugaresDeEstacion() {

    var continuar = 1

    while continuar == 1 {

        print("\n================================")

        print("      LUGARES DE LA ESTACIÓN")

        print("================================")

        print("Escribe el nombre de la estación:")

        let estacionIngresada = readLine() ?? ""

        if let estacion = obtenerNombreCorrecto(estacionIngresada) {

            let lineasEncontradas = obtenerLineasDeEstacion(estacion)

            var lugaresEncontrados: [String] = []

            for lugar in estacionDelLugar.keys {

                if estacionDelLugar[lugar] == estacion {

                    lugaresEncontrados.append(lugar)

                }

            }

            lugaresEncontrados.sort()

            print("\nEstación consultada: \(estacion)")

            if lineasEncontradas.count == 1 {

                print("Pertenece a la Línea \(lineasEncontradas[0])")

            } else {

                print("Líneas disponibles: \(convertirLineasATexto(lineasEncontradas))")

            }

            if lugaresEncontrados.isEmpty {

                print("Todavía no hay lugares registrados para esta estación.")

            } else {

                print("\nLugares importantes alrededor:")

                for lugar in lugaresEncontrados {

                    let direccion = direccionDelLugar[lugar] ?? "Dirección por validar"

                    print("\n- \(lugar)")

                    print("  Dirección: \(direccion)")

                }

            }

        } else {

            print("No se encontró la estación ingresada.")

        }

        print("\n1. Consultar otra estación")

        print("2. Volver al menú principal")

        continuar = Int(readLine() ?? "") ?? 2

    }

}

// ================================================================

// RF01 Y RF18: MENÚ PRINCIPAL Y SALIDA DEL SISTEMA

// ================================================================

var opcionPrincipal = 0

while opcionPrincipal != 5 {

    print("\n================================")

    print("        METROGUÍA LIMA")

    print("================================")

    print("1. Saber cómo llegar a un lugar")

    print("2. Viajar hacia otra estación")

    print("3. Ver lugares cercanos a una estación")

    print("4. Explorar líneas y estaciones")

    print("5. Salir")

    print("Selecciona una opción:")

    let entrada = readLine() ?? ""

    opcionPrincipal = Int(entrada) ?? 0

    if opcionPrincipal == 1 {

        saberComoLlegarAUnLugar()

    } else if opcionPrincipal == 2 {

        viajarEntreEstaciones()

    } else if opcionPrincipal == 3 {

        verLugaresDeEstacion()

    } else if opcionPrincipal == 4 {

        explorarLineas()

    } else if opcionPrincipal == 5 {

        print("Gracias por utilizar MetroGuía Lima.")

        print("Esperamos haberte ayudado a encontrar tu destino.")

    } else {

        print("Opción incorrecta. Ingresa un número del 1 al 5.")

    }

}
