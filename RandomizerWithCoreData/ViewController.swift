//
//  ViewController.swift
//  RandomizerWithCoreData
//
//  Created by Rotach Roman on 09.04.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var increaseStepper : UIStepper!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldFrom: UITextField!
    @IBOutlet weak var textFieldTo: UITextField!
    @IBOutlet weak var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resultLabelSize = 20.0
        let font = resultLabel.font?.fontName
        
        resultLabel.font = UIFont(name: font!, size: CGFloat(resultLabelSize))
        
        imageView.alpha = 0.7
        
        textFieldFrom.placeholder = "От"
        textFieldFrom.keyboardType = UIKeyboardType.numberPad
        textFieldTo.placeholder = "До"
        textFieldTo.keyboardType = UIKeyboardType.numberPad
        
        resultLabel.textAlignment = .center
        resultLabel.text = "Введите диапазон чисел"
        resultLabel.textColor = .black
        
//        actionButton.tintColor = .white
        actionButton.backgroundColor = .systemBlue
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.setTitle("Подобрать число", for: .normal)
        actionButton.contentEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
        actionButton.layer.cornerRadius = 12.5
        actionButton.layer.borderWidth = 0.4
        actionButton.layer.borderColor = UIColor.blue.cgColor
        actionButton.titleLabel?.font = UIFont(name: "", size: 20)
        actionButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        increaseStepper.value = resultLabelSize
        increaseStepper.minimumValue = 10
        increaseStepper.maximumValue = 30
        increaseStepper.stepValue = 2
        
        
        
        navigationController?.navigationBar.barTintColor = .systemGray2
        navigationItem.title = "Random numbers"
        
//        navigationController?.title = "Random numbers"
    }
 
    @IBAction func countActionButton(_ sender: UIButton) {
       
        let lowestvValue: Int = Int(textFieldFrom.text!) ?? -1
        let highesttValue: Int = Int(textFieldTo.text!) ?? -1
                       
               if (lowestvValue > -1  && highesttValue > -1) {
               
               if (highesttValue > lowestvValue) {
                   
                   let c = Int.random(in: lowestvValue..<(highesttValue+1))
                   
                   resultLabel.text = "\n"
                   resultLabel.text = "\(c)"
                   
                   } else if (highesttValue == lowestvValue) {
                       resultLabel.text = "Вы ввели одинаковые числа"
                   } else {
                       resultLabel.text = "\n"
                       resultLabel.text = "Введен неверный диапазон"
                   }
                   
               } else {
                
                   resultLabel.text = "Вы не ввели диапазон \n введите числа"
               }
        
    }
    
    
    @IBAction func increaseStepperAction(_ sender: UIStepper) {
        let font = resultLabel.font?.fontName
        let fontSize = CGFloat (sender.value)
          
        resultLabel.font = UIFont(name: font!, size: fontSize)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let navigationBar = self.navigationController?.navigationBar
//        navigationBar?.titleTextAttributes =
//    }
}




