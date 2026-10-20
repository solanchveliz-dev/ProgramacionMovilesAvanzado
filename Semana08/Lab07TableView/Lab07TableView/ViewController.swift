import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // lista de Profesores
    // lista de Profesores
    var listaProfesores = [
        Profesor(nombre: "Jaime Gomez", cargo: "Coordinador de Software", foto: UIImage(named: "PROFESOR1") ?? UIImage(systemName: "person.circle")!),
        Profesor(nombre: "Jaime Farfan", cargo: "Docente de Software TC", foto: UIImage(named: "PROFESOR2") ?? UIImage(systemName: "person.circle")!),
        Profesor(nombre: "Juan León", cargo: "Docente de Software TC", foto: UIImage(named: "PROFESOR3") ?? UIImage(systemName: "person.circle")!),
        Profesor(nombre: "Silvia Montoya", cargo: "Docente de Software TC", foto: UIImage(named: "PROFESOR4") ?? UIImage(systemName: "person.circle")!),
        Profesor(nombre: "Theobaldo Diaz", cargo: "Docente de Software TC", foto: UIImage(named: "PROFESOR5") ?? UIImage(systemName: "person.circle")!),
        Profesor(nombre: "Elliot Garamendi", cargo: "Docente de Software TC", foto: UIImage(named: "PROFESOR6") ?? UIImage(systemName: "person.circle")!),
        Profesor(nombre: "Edwin Huerto", cargo: "Docente de Redes TC", foto: UIImage(named: "PROFESOR7") ?? UIImage(systemName: "person.circle")!)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Métodos del data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaProfesores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // crear un objeto para que se muestre en la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda")!
        cell.textLabel?.text = listaProfesores[indexPath.row].nombre
        cell.detailTextLabel?.text = listaProfesores[indexPath.row].cargo
        cell.imageView?.image = listaProfesores[indexPath.row].foto
        return cell
    }
}
