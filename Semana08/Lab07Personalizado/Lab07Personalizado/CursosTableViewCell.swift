import UIKit

class CursosTableViewCell: UITableViewCell {

    @IBOutlet weak var cursoImagen: UIImageView!
    @IBOutlet weak var cursoNombre: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
