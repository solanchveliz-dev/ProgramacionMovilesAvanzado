import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    let culturas: [Cultura] = [
        Cultura(nombre: "Caral", region: "Lima (valle de Supe)",
                descripcion: "Considerada la civilización más antigua de América (aprox. 3000 a.C.). Construyó una ciudad sagrada con pirámides y plazas circulares.",
                imagen: "caral"),
        Cultura(nombre: "Chavín", region: "Áncash",
                descripcion: "Cultura religiosa con centro en Chavín de Huántar. Destaca por el Lanzón monolítico y las cabezas clavas.",
                imagen: "chavin"),
        Cultura(nombre: "Paracas", region: "Ica",
                descripcion: "Famosa por sus finos mantos textiles y por practicar trepanaciones craneanas.",
                imagen: "paracas"),
        Cultura(nombre: "Nazca", region: "Ica",
                descripcion: "Conocida por las Líneas de Nazca, su cerámica polícroma y los acueductos subterráneos.",
                imagen: "nazca"),
        Cultura(nombre: "Moche", region: "La Libertad y Lambayeque",
                descripcion: "Destacó por sus huacos retrato, la Huaca del Sol y de la Luna y la tumba del Señor de Sipán.",
                imagen: "moche"),
        Cultura(nombre: "Wari", region: "Ayacucho",
                descripcion: "Considerado el primer imperio andino, con ciudades planificadas y una red de caminos.",
                imagen: "wari"),
        Cultura(nombre: "Chimú", region: "La Libertad",
                descripcion: "Construyó Chan Chan, la ciudad de barro más grande de América, y fue experta en orfebrería.",
                imagen: "chimu"),
        Cultura(nombre: "Inca", region: "Cusco",
                descripcion: "Formó el Tahuantinsuyo, el imperio más grande de América precolombina. Construyó Machu Picchu y el Qhapaq Ñan.",
                imagen: "inca")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Culturas Peruanas"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 90
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let seleccionada = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: seleccionada, animated: true)
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return culturas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CulturaCell", for: indexPath) as! CulturaCell
        let cultura = culturas[indexPath.row]
        cell.nombreLabel.text = cultura.nombre
        cell.culturaImageView.image = UIImage(named: cultura.imagen) ?? UIImage(systemName: "photo")
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - Navegación
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetalle",
           let destino = segue.destination as? DetalleViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destino.cultura = culturas[indexPath.row]
        }
    }
}
