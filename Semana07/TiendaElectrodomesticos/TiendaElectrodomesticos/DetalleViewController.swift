
import UIKit

class DetalleViewController: UIViewController {

    // MARK: - Conexiones de la pantalla


    @IBOutlet weak var imagenProducto: UIImageView!
    
    @IBOutlet weak var nombreProductoLabel: UILabel!
    
    @IBOutlet weak var precioProductoLabel: UILabel!
    // MARK: - Datos del producto

    @IBOutlet weak var stockLabel: UILabel!
    
    @IBOutlet weak var cantidadLabel: UILabel!
    var producto: Producto?
    var carrito: CarritoModel?

    var cantidadSeleccionada: Int = 1

    // MARK: - Inicio de la pantalla

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Detalle del producto"
        mostrarProducto()
    }

    // MARK: - Mostrar información

    func mostrarProducto() {
        guard let producto = producto else { return }

        nombreProductoLabel.text = producto.nombre
        precioProductoLabel.text = String(
            format: "S/ %.2f",
            producto.precio
        )

        stockLabel.text = "\(producto.stock) unidades"

        cantidadSeleccionada = 1
        actualizarCantidad()
    }

    // MARK: - Actualizar cantidad

    func actualizarCantidad() {
        cantidadLabel.text = "\(cantidadSeleccionada)"
    }

    // MARK: - Aumentar cantidad

    @IBAction func aumentarCantidad(_ sender: UIButton) {
        guard let producto = producto else { return }

        if cantidadSeleccionada < producto.stock {
            cantidadSeleccionada += 1
            actualizarCantidad()
        }
    }

    // MARK: - Disminuir cantidad

    @IBAction func disminuirCantidad(_ sender: UIButton) {
        if cantidadSeleccionada > 0 {
            cantidadSeleccionada -= 1
            actualizarCantidad()
        }
    }
    
    // MARK: - Agregar al carrito

    @IBAction func agregarAlCarrito(_ sender: UIButton) {
        guard let producto = producto,
              let carrito = carrito else {
            return
        }

        guard cantidadSeleccionada > 0 else {
            mostrarMensaje(
                titulo: "Cantidad inválida",
                mensaje: "Selecciona al menos 1 unidad."
            )
            return
        }

        let agregado = carrito.agregar(
            producto: producto,
            cantidad: cantidadSeleccionada
        )

        if agregado {
            mostrarMensaje(
                titulo: "¡Producto agregado!",
                mensaje: "\(cantidadSeleccionada) unidad(es) de \(producto.nombre) agregadas al carrito."
            )
        } else {
            mostrarMensaje(
                titulo: "Stock insuficiente",
                mensaje: "No hay suficientes unidades disponibles."
            )
        }
    }

    // MARK: - Mostrar mensajes

    func mostrarMensaje(titulo: String, mensaje: String) {
        let alerta = UIAlertController(
            title: titulo,
            message: mensaje,
            preferredStyle: .alert
        )

        alerta.addAction(
            UIAlertAction(title: "Aceptar", style: .default)
        )

        present(alerta, animated: true)
    }

}
