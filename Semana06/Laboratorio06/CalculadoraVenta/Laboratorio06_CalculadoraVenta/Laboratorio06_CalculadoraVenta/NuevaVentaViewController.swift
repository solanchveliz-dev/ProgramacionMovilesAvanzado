import UIKit

class NuevaVentaViewController: UIViewController {

    @IBOutlet weak var tfElectrodomestico: UITextField!
    @IBOutlet weak var tfPrecio: UITextField!
    @IBOutlet weak var tfCantidad: UITextField!
    @IBOutlet weak var tfMeses: UITextField!
    @IBOutlet weak var tfInteres: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado" {
            // leer datos (si esta vacio, vale 0)
            let precio = Double(tfPrecio.text ?? "") ?? 0
            let cantidad = Double(tfCantidad.text ?? "") ?? 0
            let meses = Double(tfMeses.text ?? "") ?? 0
            let tasa = Double(tfInteres.text ?? "") ?? 0
            
            // formulas
            let subtotal = precio * cantidad
            let igv = subtotal * 0.18
            let base = subtotal + igv
            let intereses = base * (tasa / 100) * meses
            let total = base + intereses
            let cuota = meses > 0 ? total / meses : 0
            
            // armar el modelo y pasarlo a Resultado
            let oVenta = VentaModel(pSubtotal: subtotal, pIgv: igv, pBase: base,
                                    pIntereses: intereses, pTotal: total, pCuota: cuota)
            let oResultado = segue.destination as! ResultadoViewController
            oResultado.pVenta = oVenta
        }
    }
        // ocultar el teclado al tocar fuera de los campos
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    }

