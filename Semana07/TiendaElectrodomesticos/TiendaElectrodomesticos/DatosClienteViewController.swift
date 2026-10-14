

import UIKit

class DatosClienteViewController: UIViewController {

    // MARK: - Conexiones de la pantalla

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!

    // MARK: - Datos recibidos

    var carrito: CarritoModel?
    var cliente: ClienteModel?

    // MARK: - Inicio

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Datos del cliente"

        nombreTextField.placeholder = "Ingresa tu nombre completo"
        dniTextField.placeholder = "Ingresa tu DNI"
        direccionTextField.placeholder = "Ingresa tu dirección"

        dniTextField.keyboardType = .numberPad
        nombreTextField.autocapitalizationType = .words
        direccionTextField.autocapitalizationType = .words
    }

    // MARK: - Continuar

    @IBAction func continuar(_ sender: UIButton) {

        // Obtener los datos ingresados
        let nombre = nombreTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let dni = dniTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        let direccion = direccionTextField.text?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Validar campos vacíos
        guard !nombre.isEmpty,
              !dni.isEmpty,
              !direccion.isEmpty else {
            mostrarAlerta(
                titulo: "Campos incompletos",
                mensaje: "Completa tu nombre, DNI y dirección."
            )
            return
        }

        // Validar DNI peruano de 8 dígitos
        guard dni.count == 8,
              dni.allSatisfy({ $0.isNumber }) else {
            mostrarAlerta(
                titulo: "DNI inválido",
                mensaje: "El DNI debe contener exactamente 8 números."
            )
            return
        }

        // Guardar los datos del cliente
        cliente = ClienteModel(
            nombre: nombre,
            dni: dni,
            direccion: direccion
        )

        // Ir a la pantalla de la boleta
        performSegue(withIdentifier: "verBoleta", sender: nil)
    }

    // MARK: - Preparar siguiente pantalla

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if segue.identifier == "verBoleta",
           let destino = segue.destination as? BoletaViewController {

            destino.carrito = carrito
            destino.cliente = cliente
        }
    }

    // MARK: - Mensajes

    func mostrarAlerta(titulo: String, mensaje: String) {
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
