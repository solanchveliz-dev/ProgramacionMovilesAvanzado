

import UIKit

class BoletaViewController: UIViewController {

    // MARK: - Datos recibidos

    var carrito: CarritoModel?
    var cliente: ClienteModel?

    // MARK: - Conexiones del Storyboard
    // Conectaremos estas etiquetas en el siguiente paso.

    @IBOutlet weak var nombreClienteLabel: UILabel!
    @IBOutlet weak var dniLabel: UILabel!
    @IBOutlet weak var direccionLabel: UILabel!

    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    @IBOutlet weak var productosLabel: UILabel!

    // MARK: - Inicio

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Boleta de compra"
        mostrarDatosBoleta()
    }

    // MARK: - Mostrar datos

    func mostrarDatosBoleta() {
        guard let cliente = cliente,
              let carrito = carrito else {
            return
        }

        nombreClienteLabel.text = cliente.nombre
        dniLabel.text = cliente.dni
        direccionLabel.text = cliente.direccion

        subtotalLabel.text = String(
            format: "S/ %.2f", carrito.subtotal
        )

        descuentoLabel.text = String(
            format: "S/ %.2f", carrito.descuento
        )

        igvLabel.text = String(
            format: "S/ %.2f", carrito.igv
        )

        totalLabel.text = String(
            format: "S/ %.2f", carrito.total
        )

        productosLabel.text = carrito.items.map { item in
            "\(item.producto.nombre) x\(item.cantidad) — " +
            String(format: "S/ %.2f", item.subtotal)
        }.joined(separator: "\n")
    }

    // MARK: - Cerrar boleta

    @IBAction func cerrarBoleta(_ sender: UIButton) {
        navigationController?.popToRootViewController(
            animated: true
        )
    }

    // MARK: - Volver al catálogo

    @IBAction func volverAlCatalogo(_ sender: UIButton) {
        navigationController?.popToRootViewController(
            animated: true
        )
    }
}
