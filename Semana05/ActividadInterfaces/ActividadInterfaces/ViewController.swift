//
//  ViewController.swift
//  ActividadInterfaces
//
//  Created by Naomi Solanch Veliz Pie on 20/09/26.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var capitalTextField:UITextField!
    @IBOutlet weak var tasaTextField: UITextField!
    @IBOutlet weak var plazoTextField: UITextField!
    
    
    @IBOutlet weak var cuotaLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func calcularPrestamo(_ sender: UIButton) {
        guard
              let capitalTexto = capitalTextField.text,
              let tasaTexto = tasaTextField.text,
              let plazoTexto = plazoTextField.text else {
            return
            
        }
        let capital = Double(capitalTexto) ?? 0
        let tasaAnual = Double(tasaTexto) ?? 0
        let plazoAnios = Double(plazoTexto) ?? 0
        
        print("Capital:", capital)
        print("Tasa:", tasaAnual)
        print("Plazo:", plazoAnios)
        
    }
}

