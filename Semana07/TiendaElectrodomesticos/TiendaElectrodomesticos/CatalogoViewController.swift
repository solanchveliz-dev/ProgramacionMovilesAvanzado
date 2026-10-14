import UIKit

class CatalogoViewController: UIViewController {

    // MARK: - PRODUCTOS
    // El orden coincide con los Tags:
    // Refrigeradora = 0, Licuadora = 1, Laptop = 2, Cocina = 3
    let productos: [Producto] = [
        Producto(nombre: "Refrigeradora", precio: 2000, stock: 5),
        Producto(nombre: "Licuadora", precio: 250, stock: 10),
        Producto(nombre: "Laptop", precio: 3500, stock: 3),
        Producto(nombre: "Cocina", precio: 1200, stock: 4)
    ]

    // MARK: - CARRITO ÚNICO (se crea solo aquí)
    let carrito = CarritoModel()

    // MARK: - OUTLETS
    // Botón "Ver carrito (0)"
    @IBOutlet weak var cartButton: UIButton!

    // MARK: - CICLO DE VIDA
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tienda Tecsup"
    }

    // Se actualiza cada vez que volvemos al Catálogo
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartButton()
    }

    // MARK: - BOTONES DE PRODUCTOS
    @IBAction func openDetailRefrigerator(_ sender: UIButton) {
        openProductDetail(sender)
    }

    @IBAction func openDetailBlender(_ sender: UIButton) {
        openProductDetail(sender)
    }

    @IBAction func openDetailLaptop(_ sender: UIButton) {
        openProductDetail(sender)
    }

    @IBAction func openDetailCook(_ sender: UIButton) {
        openProductDetail(sender)
    }

    // Un solo segue para los 4 productos: se envía el botón como sender
    private func openProductDetail(_ sender: UIButton) {
        performSegue(withIdentifier: "verDetalle", sender: sender)
    }

    // MARK: - BOTÓN VER CARRITO
    @IBAction func openCart(_ sender: UIButton) {
        performSegue(withIdentifier: "verCarrito", sender: nil)
    }

    // Suma todas las cantidades del carrito
    func updateCartButton() {
        var cantidad = 0
        for item in carrito.items {
            cantidad += item.cantidad
        }
        cartButton?.setTitle("Ver carrito (\(cantidad))", for: .normal)
    }

    // MARK: - PASO DE DATOS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verDetalle" {
            guard let destino = segue.destination as? DetalleViewController,
                  let boton = sender as? UIButton,
                  productos.indices.contains(boton.tag) else {
                return
            }
            destino.producto = productos[boton.tag]
            destino.carrito = carrito

        } else if segue.identifier == "verCarrito" {
            guard let destino = segue.destination as? CarritoViewController else {
                return
            }
            destino.carrito = carrito
        }
    }
}
