import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!

    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cultura = cultura else { return }

        title = cultura.nombre
        nombreLabel.text = cultura.nombre
        regionLabel.text = "Región: \(cultura.region)"
        descripcionLabel.text = cultura.descripcion
        imagenView.image = UIImage(named: cultura.imagen) ?? UIImage(systemName: "photo")
    }
}
