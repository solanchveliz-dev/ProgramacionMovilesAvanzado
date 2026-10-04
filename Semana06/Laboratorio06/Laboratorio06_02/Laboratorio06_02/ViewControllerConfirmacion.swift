//
//  ViewControllerConfirmacion.swift
//  Laboratorio06_02
//
//  Created by Naomi Solanch Veliz Pie on 4/10/26.
//

import UIKit

class ViewControllerConfirmacion: UIViewController {
    
    var pCliente: ClienteModel = ClienteModel()
    
    @IBOutlet weak var tfApellido: UILabel!
    
    @IBOutlet weak var tfNombre: UILabel!
    
    @IBOutlet weak var tfDni: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfApellido.text = pCliente.Apellido
        self.tfNombre.text = pCliente.Nombre
        self.tfDni.text = pCliente.Dni
    }
    
    @IBAction func btnVolver(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
