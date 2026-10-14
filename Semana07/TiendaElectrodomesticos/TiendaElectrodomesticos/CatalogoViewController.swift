
import UIKit

class CatalogoViewController: UIViewController {

    // MARK: - PRODUCTS
    // El orden de los productos debe coincidir con los Tags:
    // Refrigeradora = 0, Licuadora = 1, Laptop = 2, Cocina = 3.

    let productos: [Producto] = [
        Producto(nombre: "Refrigeradora", precio: 2000, stock: 5),
        Producto(nombre: "Licuadora", precio: 250, stock: 10),
        Producto(nombre: "Laptop", precio: 3500, stock: 3),
        Producto(nombre: "Cocina", precio: 1200, stock: 4)
    ]

    // MARK: - SHARED CART
    // Todas las pantallas usarán esta misma instancia del carrito.

    let carrito = CarritoModel()

    // MARK: - STORYBOARD OUTLETS

    // Conecta el botón "Ver carrito (0)" a este Outlet.


    @IBOutlet weak var cartButton: UIButton!
    // MARK: - VIEW LIFECYCLE

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tienda Tecsup"
        updateCartButton()
    }

    // MARK: - PRODUCT BUTTON ACTIONS

    // Botón Refrigeradora: Tag 0.
    @IBAction func openDetailRefrigerator(_ sender: UIButton) {
        openProductDetail(sender)
    }

    // Botón Licuadora: Tag 1.
    @IBAction func openDetailBlender(_ sender: UIButton) {
        openProductDetail(sender)
    }

    // Botón Laptop: Tag 2.
    @IBAction func openDetailLaptop(_ sender: UIButton) {
        openProductDetail(sender)
    }

    // Botón Cocina: Tag 3.
    @IBAction func openDetailCook(_ sender: UIButton) {
        openProductDetail(sender)
    }

    // Función compartida para abrir el detalle del producto seleccionado.
    private func openProductDetail(_ sender: UIButton) {
        let index = sender.tag

        guard productos.indices.contains(index) else {
            return
        }

        let selectedProduct = productos[index]

        performSegue(
            withIdentifier: "verDetalle",
            sender: selectedProduct
        )
    }

    // MARK: - CART BUTTON ACTION

    // Conecta el botón "Ver carrito (0)" con esta acción.
    @IBAction func openCart(_ sender: UIButton) {
        performSegue(
            withIdentifier: "verCarrito",
            sender: nil
        )
    }

    // MARK: - UPDATE CART BUTTON

    // Actualiza el número total de unidades agregadas al carrito.
    func updateCartButton() {
        let quantity = carrito.items.reduce(0) {
            $0 + $1.cantidad
        }

        cartButton?.setTitle(
            "Ver carrito (\(quantity))",
            for: .normal
        )
    }

    // Actualiza el contador cuando regresamos al catálogo.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartButton()
    }

    // MARK: - PASS DATA BETWEEN SCREENS

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "verDetalle" {

            // Enviar el producto seleccionado y el carrito compartido.
            guard let destination =
                    segue.destination as? DetalleViewController,
                  let product = sender as? Producto else {
                return
            }

            destination.producto = product
            destination.carrito = carrito

        } else if segue.identifier == "verCarrito" {

            // Enviar el mismo carrito a la pantalla Carrito.
            guard let destination =
                    segue.destination as? CarritoViewController else {
                return
            }

            destination.carrito = carrito
        }
    }
}
