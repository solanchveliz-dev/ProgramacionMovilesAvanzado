import Foundation

// ====================================================
// ACTIVIDAD PROPUESTA 01: FACTURA DE CURSOS
// ====================================================

struct Curso {
    let nombre: String
    let precio: Double
    let cantidad: Int

    func calcularTotal() -> Double {
        return precio * Double(cantidad)
    }
}

struct Estudiante {
    let nombre: String
    let dni: String
    let esAlumnoTecsup: Bool
}

class FacturaCursos {
    let estudiante: Estudiante
    var cursos: [Curso]

    let porcentajeIGV: Double = 0.18
    let porcentajeDescuento: Double = 0.10
    let descuentoTecsup: Double = 400.00

    init(estudiante: Estudiante, cursos: [Curso]) {
        self.estudiante = estudiante
        self.cursos = cursos
    }

    func calcularCantidadCursos() -> Int {
        var cantidadTotal = 0

        for curso in cursos {
            cantidadTotal += curso.cantidad
        }

        return cantidadTotal
    }

    func calcularSubtotal() -> Double {
        var subtotal = 0.0

        for curso in cursos {
            subtotal += curso.calcularTotal()
        }

        return subtotal
    }

    func calcularIGV() -> Double {
        return calcularSubtotal() * porcentajeIGV
    }

    func calcularTotalConIGV() -> Double {
        return calcularSubtotal() + calcularIGV()
    }

    func calcularDescuentoCantidad() -> Double {
        if calcularCantidadCursos() >= 3 {
            return calcularTotalConIGV() * porcentajeDescuento
        } else {
            return 0.0
        }
    }

    func calcularDescuentoTecsup() -> Double {
        if estudiante.esAlumnoTecsup &&
            calcularCantidadCursos() >= 3 {
            return descuentoTecsup
        } else {
            return 0.0
        }
    }

    func calcularTotalFinal() -> Double {
        return calcularTotalConIGV()
            - calcularDescuentoCantidad()
            - calcularDescuentoTecsup()
    }

    func formatoMoneda(_ monto: Double) -> String {
        return String(format: "%.2f", monto)
    }

    func mostrarFactura() {
        print("===== FACTURA DE CURSOS =====")
        print("Estudiante: \(estudiante.nombre)")
        print("DNI: \(estudiante.dni)")

        if estudiante.esAlumnoTecsup {
            print("Alumno de Tecsup: Sí")
        } else {
            print("Alumno de Tecsup: No")
        }

        print("------------------------------")

        for curso in cursos {
            let totalCurso = curso.calcularTotal()

            print(
                "\(curso.nombre) x\(curso.cantidad) - " +
                "S/ \(formatoMoneda(totalCurso))"
            )
        }

        print("------------------------------")

        print(
            "Subtotal: S/ " +
            formatoMoneda(calcularSubtotal())
        )

        print(
            "IGV (18%): S/ " +
            formatoMoneda(calcularIGV())
        )

        print(
            "Total con IGV: S/ " +
            formatoMoneda(calcularTotalConIGV())
        )

        if calcularDescuentoCantidad() > 0 {
            print(
                "Descuento 10% por cantidad: -S/ " +
                formatoMoneda(calcularDescuentoCantidad())
            )
        }

        if calcularDescuentoTecsup() > 0 {
            print(
                "Descuento especial Tecsup: -S/ " +
                formatoMoneda(calcularDescuentoTecsup())
            )
        }

        print("------------------------------")

        print(
            "TOTAL FINAL A PAGAR: S/ " +
            formatoMoneda(calcularTotalFinal())
        )
    }
}

// Datos para probar la actividad 01.

let estudianteCursos = Estudiante(
    nombre: "Naomi Veliz",
    dni: "78965412",
    esAlumnoTecsup: true
)

let cursosComprados: [Curso] = [
    Curso(
        nombre: "Swift Avanzado",
        precio: 450.00,
        cantidad: 1
    ),
    Curso(
        nombre: "IA con Python",
        precio: 650.00,
        cantidad: 2
    ),
    Curso(
        nombre: "Diseño UX/UI",
        precio: 500.00,
        cantidad: 1
    )
]

let factura = FacturaCursos(
    estudiante: estudianteCursos,
    cursos: cursosComprados
)

factura.mostrarFactura()

print("")
