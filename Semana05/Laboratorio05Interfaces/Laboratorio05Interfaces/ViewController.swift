//
//  ViewController.swift
//  Laboratorio05Interfaces
//
//  Created by Naomi Solanch Veliz Pie on 16/09/26.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var weightTextField: UITextField!
    
    @IBOutlet weak var heightTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "Introduce tu peso y altura"
        
    }

    
    @IBAction func calcularResultado(_ sender: Any) {
        view.endEditing(true)
        // Obtener los valores de peso y altura
               let weight = Double(weightTextField.text ?? "") ?? 0
               let height = Double(heightTextField.text ?? "") ?? 0

               // Verificar si los valores ingresados son válidos
               if weight == 0 || height == 0 {
                   resultLabel.text = "Por favor, ingresa valores válidos."
                   return
               }

               // Calcular el IMC
               let bmi = weight / (height * height)

               // Determinar la clasificación del IMC
               var status = ""

               if bmi < 18.5 {
                   status = "Bajo peso"
               } else if bmi < 24.9 {
                   status = "Peso normal"
               } else if bmi < 29.9 {
                   status = "Sobrepeso"
               } else {
                   status = "Obesidad"
               }

               // Mostrar el resultado
               resultLabel.text =
                   "IMC: \(String(format: "%.2f", bmi)) - \(status)"
           }
       }
