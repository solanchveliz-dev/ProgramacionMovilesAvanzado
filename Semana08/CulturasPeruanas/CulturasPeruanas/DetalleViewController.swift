import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var imagenView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!

    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configurarDiseno()
        mostrarDatos()
    }

    private func configurarDiseno() {
        // Stack View que contiene la imagen y los labels
        if let stack = imagenView.superview as? UIStackView {
            // Quitar constraints del storyboard que tocan al stack
            let viejas = view.constraints.filter { $0.firstItem === stack || $0.secondItem === stack }
            NSLayoutConstraint.deactivate(viejas)

            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.spacing = 12
            stack.alignment = .fill

            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
        }

        // Imagen con altura fija
        imagenView.removeConstraints(imagenView.constraints)
        imagenView.translatesAutoresizingMaskIntoConstraints = false
        imagenView.heightAnchor.constraint(equalToConstant: 220).isActive = true
        imagenView.contentMode = .scaleAspectFill
        imagenView.clipsToBounds = true
        imagenView.layer.cornerRadius = 16

        // Textos
        nombreLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nombreLabel.textColor = .label

        regionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        regionLabel.textColor = .secondaryLabel

        descripcionLabel.font = .systemFont(ofSize: 16)
        descripcionLabel.textColor = .label
        descripcionLabel.numberOfLines = 0
    }

    private func mostrarDatos() {
        guard let cultura = cultura else { return }
        title = cultura.nombre
        navigationItem.largeTitleDisplayMode = .never
        nombreLabel.text = cultura.nombre
        regionLabel.text = "📍 Región: \(cultura.region)"
        descripcionLabel.text = cultura.descripcion
        imagenView.image = UIImage(named: cultura.imagen) ?? UIImage(systemName: "photo")
    }
}
