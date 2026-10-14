
import UIKit

class CarritoViewController: UIViewController {

    // MARK: - Conexiones de la pantalla

    @IBOutlet weak var tablaCarrito: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var descuentoLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var categoriaLabel: UILabel!

    // MARK: - Carrito compartido

    var carrito: CarritoModel?

    // MARK: - Inicio

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Mi Carrito"

        tablaCarrito.dataSource = self
        actualizarResumen()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tablaCarrito.reloadData()
        actualizarResumen()
    }

    // MARK: - Actualizar totales

    func actualizarResumen() {
        guard let carrito = carrito else { return }

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

        categoriaLabel.text = carrito.categoria
    }
    // MARK: - Continuar compra

    @IBAction func continuarCompra(_ sender: UIButton) {
        performSegue(withIdentifier: "continuarCompra", sender: nil)
    }
}

// MARK: - Tabla de productos

extension CarritoViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return carrito?.items.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let celda = tableView.dequeueReusableCell(
            withIdentifier: "celdaProducto",
            for: indexPath
        )

        guard let item = carrito?.items[indexPath.row] else {
            return celda
        }

        if let celdaPersonalizada = celda as? ProductoCarritoCell {
            celdaPersonalizada.nombreProductoLabel.text =
                item.producto.nombre

            celdaPersonalizada.cantidadLabel.text =
                "Cantidad: \(item.cantidad)"

            celdaPersonalizada.precioLabel.text = String(
                format: "S/ %.2f", item.subtotal
            )
        }

        return celda
    }
}
