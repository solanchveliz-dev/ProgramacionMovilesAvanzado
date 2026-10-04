//
//  ViewController.swift
//  Laboratorio06_02
//
//  Created by Naomi Solanch Veliz Pie on 4/10/26.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tfApellido: UITextField!
    
    @IBOutlet weak var tfNombre: UITextField!
    
    @IBOutlet weak var tfDni: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnContinuar(_ sender: Any) {
        let oCliente: ClienteModel = ClienteModel(pCodigo: 0,
                                                  pApellido: self.tfApellido.text!,
                                                  pNombre: self.tfNombre.text!,
                                                  pDni: self.tfDni.text!)
        // crear el Storyboard con el nombre Main, se asocia a la pantalla 2
        // le pasamos los datos del cliente
        let osb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let oPantalla2 = osb.instantiateViewController(identifier: "ViewControllerConfirmacion") as! ViewControllerConfirmacion
        oPantalla2.pCliente = oCliente
        self.present(oPantalla2, animated: true, completion: nil)
    }
    // ocultar el teclado al tocar fuera de los campos
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

