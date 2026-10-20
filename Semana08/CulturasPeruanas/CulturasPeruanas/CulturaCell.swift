import UIKit

class CulturaCell: UITableViewCell {

    @IBOutlet weak var culturaImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    let regionLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        configurarDiseno()
    }

    private func configurarDiseno() {
        // Si no hay imagen o label conectados, no hacer nada (evita el crash)
        guard culturaImageView != nil, nombreLabel != nil else { return }

        // Quitar las constraints del storyboard para usar las del código
        contentView.removeConstraints(contentView.constraints)
        culturaImageView.removeConstraints(culturaImageView.constraints)
        nombreLabel.removeConstraints(nombreLabel.constraints)

        culturaImageView.translatesAutoresizingMaskIntoConstraints = false
        nombreLabel.translatesAutoresizingMaskIntoConstraints = false
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(regionLabel)

        // Imagen: todas del mismo tamaño y con esquinas redondeadas
        culturaImageView.contentMode = .scaleAspectFill
        culturaImageView.clipsToBounds = true
        culturaImageView.layer.cornerRadius = 12

        // Textos
        nombreLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nombreLabel.textColor = .label
        nombreLabel.textAlignment = .left

        regionLabel.font = .systemFont(ofSize: 14)
        regionLabel.textColor = .secondaryLabel

        NSLayoutConstraint.activate([
            culturaImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            culturaImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            culturaImageView.widthAnchor.constraint(equalToConstant: 70),
            culturaImageView.heightAnchor.constraint(equalToConstant: 70),

            nombreLabel.leadingAnchor.constraint(equalTo: culturaImageView.trailingAnchor, constant: 14),
            nombreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nombreLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),

            regionLabel.leadingAnchor.constraint(equalTo: nombreLabel.leadingAnchor),
            regionLabel.trailingAnchor.constraint(equalTo: nombreLabel.trailingAnchor),
            regionLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 2)
        ])
    }
}
