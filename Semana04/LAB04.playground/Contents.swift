// ===== CASO 2: BIBLIOTECA =====

// MARK: - Estado del libro

enum EstadoLibro {
    case disponible
    case prestado
}

// MARK: - Libro

struct Libro {
    let titulo: String
    let autor: String
    var estado: EstadoLibro

    init(titulo: String, autor: String) {
        self.titulo = titulo
        self.autor = autor
        self.estado = .disponible
    }
}

// MARK: - Biblioteca

class Biblioteca {
    var libros: [Libro] = []

    // Agrega un libro al arreglo.
    func agregar(libro: Libro) {
        libros.append(libro)
    }

    // Busca y presta un libro.
    func prestar(titulo: String) -> Bool {
        for i in 0..<libros.count {

            if libros[i].titulo == titulo {

                if libros[i].estado == .disponible {
                    libros[i].estado = .prestado
                    print("Préstamo aprobado: \(titulo)")
                    return true
                } else {
                    print("Error: \(titulo) ya está prestado")
                    return false
                }
            }
        }

        print("Error: no existe \(titulo)")
        return false
    }

    // Busca y devuelve un libro.
    func devolver(titulo: String) -> Bool {
        for i in 0..<libros.count {

            if libros[i].titulo == titulo {

                if libros[i].estado == .prestado {
                    libros[i].estado = .disponible
                    print("Devolución registrada: \(titulo)")
                    return true
                } else {
                    print("Error: \(titulo) ya está disponible")
                    return false
                }
            }
        }

        print("Error: no existe \(titulo)")
        return false
    }

    // Muestra todos los libros.
    func inventario() {
        print("===== INVENTARIO =====")

        for libro in libros {
            switch libro.estado {
            case .disponible:
                print("\(libro.titulo) (\(libro.autor)) - disponible")

            case .prestado:
                print("\(libro.titulo) (\(libro.autor)) - prestado")
            }
        }
    }
}

// MARK: - Simulación

let biblioteca = Biblioteca()

let libro1 = Libro(
    titulo: "Cien años de soledad",
    autor: "Gabriel García Márquez"
)

let libro2 = Libro(
    titulo: "La ciudad y los perros",
    autor: "Mario Vargas Llosa"
)

let libro3 = Libro(
    titulo: "El Quijote",
    autor: "Miguel de Cervantes"
)

// Agregamos los libros.
biblioteca.agregar(libro: libro1)
biblioteca.agregar(libro: libro2)
biblioteca.agregar(libro: libro3)

// Realizamos las operaciones solicitadas.
biblioteca.prestar(titulo: "La ciudad y los perros")
biblioteca.prestar(titulo: "La ciudad y los perros")
biblioteca.devolver(titulo: "La ciudad y los perros")
biblioteca.prestar(titulo: "El Quijote")
biblioteca.prestar(titulo: "El Principito")

// Mostramos el resultado final.
biblioteca.inventario()
