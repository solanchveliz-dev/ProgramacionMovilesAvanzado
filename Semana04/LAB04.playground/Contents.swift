// ===== CASO 2 — PARTE B: BIBLIOTECA (CON IA) =====

// Define los estados posibles de un libro.
enum EstadoLibro {
    // Indica que el libro puede prestarse.
    case disponible

    // Indica que el libro ya fue prestado.
    case prestado
}

// Representa los datos de cada libro.
struct Libro {
    // Guarda el título y no permite modificarlo.
    let titulo: String

    // Guarda el autor y no permite modificarlo.
    let autor: String

    // Guarda el estado y permite cambiarlo.
    var estado: EstadoLibro

    // Inicializa un libro con su título y autor.
    init(titulo: String, autor: String) {
        // Asigna el título recibido.
        self.titulo = titulo

        // Asigna el autor recibido.
        self.autor = autor

        // Todos los libros comienzan disponibles.
        self.estado = .disponible
    }
}

// Administra la colección y los préstamos.
class Biblioteca {
    // Crea un arreglo vacío de libros.
    var libros: [Libro] = []

    // Agrega un libro nuevo al arreglo.
    func agregar(libro: Libro) {
        // Coloca el libro al final del arreglo.
        libros.append(libro)
    }

    // Busca un título y devuelve true si consigue prestarlo.
    func prestar(titulo: String) -> Bool {
        // Recorre el arreglo utilizando sus índices.
        for i in 0..<libros.count {
            // Comprueba si el título actual coincide con el buscado.
            if libros[i].titulo == titulo {
                // Comprueba si el libro se encuentra disponible.
                if libros[i].estado == .disponible {
                    // Modifica el struct directamente dentro del arreglo.
                    libros[i].estado = .prestado

                    // Informa que el préstamo fue realizado.
                    print("Préstamo aprobado: \(titulo)")

                    // Indica que la operación tuvo éxito.
                    return true
                } else {
                    // Informa que el libro ya se encuentra prestado.
                    print("Error: \(titulo) ya está prestado")

                    // Indica que la operación no pudo realizarse.
                    return false
                }
            }
        }

        // Se ejecuta si el título no se encontró en el arreglo.
        print("Error: no existe \(titulo)")

        // Indica que el préstamo no se realizó.
        return false
    }

    // Busca un título y devuelve true si consigue devolverlo.
    func devolver(titulo: String) -> Bool {
        // Recorre el arreglo utilizando sus índices.
        for i in 0..<libros.count {
            // Comprueba si el título actual coincide con el buscado.
            if libros[i].titulo == titulo {
                // Comprueba si el libro se encuentra prestado.
                if libros[i].estado == .prestado {
                    // Modifica el struct directamente dentro del arreglo.
                    libros[i].estado = .disponible

                    // Informa que la devolución fue registrada.
                    print("Devolución registrada: \(titulo)")

                    // Indica que la operación tuvo éxito.
                    return true
                } else {
                    // Informa que el libro ya estaba disponible.
                    print("Error: \(titulo) ya está disponible")

                    // Indica que la operación no pudo realizarse.
                    return false
                }
            }
        }

        // Se ejecuta si el título no se encontró en el arreglo.
        print("Error: no existe \(titulo)")

        // Indica que la devolución no se realizó.
        return false
    }

    // Muestra todos los libros con su autor y estado.
    func inventario() {
        // Imprime el encabezado solicitado.
        print("===== INVENTARIO =====")

        // Recorre cada libro almacenado.
        for libro in libros {
            // Evalúa el estado del libro.
            switch libro.estado {
            // Se ejecuta cuando el libro está disponible.
            case .disponible:
                // Imprime los datos y el estado disponible.
                print("\(libro.titulo) (\(libro.autor)) - disponible")

            // Se ejecuta cuando el libro está prestado.
            case .prestado:
                // Imprime los datos y el estado prestado.
                print("\(libro.titulo) (\(libro.autor)) - prestado")
            }
        }
    }
}

// Crea la única biblioteca de la simulación.
let biblioteca = Biblioteca()

// Crea el primer libro inicialmente disponible.
let libro1 = Libro(
    titulo: "Cien años de soledad",
    autor: "Gabriel García Márquez"
)

// Crea el segundo libro inicialmente disponible.
let libro2 = Libro(
    titulo: "La ciudad y los perros",
    autor: "Mario Vargas Llosa"
)

// Crea el tercer libro inicialmente disponible.
let libro3 = Libro(
    titulo: "El Quijote",
    autor: "Miguel de Cervantes"
)

// Agrega el primer libro a la biblioteca.
biblioteca.agregar(libro: libro1)

// Agrega el segundo libro a la biblioteca.
biblioteca.agregar(libro: libro2)

// Agrega el tercer libro a la biblioteca.
biblioteca.agregar(libro: libro3)

// Presta La ciudad y los perros correctamente.
_ = biblioteca.prestar(titulo: "La ciudad y los perros")

// Intenta prestar nuevamente el mismo libro.
_ = biblioteca.prestar(titulo: "La ciudad y los perros")

// Devuelve La ciudad y los perros.
_ = biblioteca.devolver(titulo: "La ciudad y los perros")

// Presta El Quijote.
_ = biblioteca.prestar(titulo: "El Quijote")

// Intenta prestar un libro que no existe.
_ = biblioteca.prestar(titulo: "El Principito")

// Muestra el inventario después de las operaciones.
biblioteca.inventario()
