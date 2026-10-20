import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // definir los arreglos que carguen los nombres e imágenes
    var cursosArreglo = [
        "Programación en Móviles Avanzado",
        "Desarrollo de Aplicaciones Web Avanzado",
        "Desarrollo de Soluciones en la Nube",
        "Integración de Sistemas Empresariales",
        "Diseño de Proyectos de Innovación"
    ]
    var cursosImagenArreglo = ["moviles", "web", "nube", "integracion", "innovacion"]

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cursosArreglo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miCell") as? CursosTableViewCell
        cell?.cursoNombre.text = "\(cursosArreglo[indexPath.row])"
        cell?.cursoImagen.image = UIImage(named: "\(cursosImagenArreglo[indexPath.row])")
        return cell!
    }

    // alerta al seleccionar un curso
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alerta = UIAlertController(title: "El curso que seleccionó es:",
                                       message: "\(cursosArreglo[indexPath.row])",
                                       preferredStyle: UIAlertController.Style.alert)
        // activar el botón OK
        alerta.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (action: UIAlertAction) in
        }))
        self.present(alerta, animated: true, completion: nil)
    }
}
