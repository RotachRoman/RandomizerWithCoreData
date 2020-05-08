//
//  RegisterViewController.swift
//  RandomizerWithCoreData
//
//  Created by Rotach Roman on 27.04.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwodTextField: UITextField!
    @IBOutlet weak var passwordcCnfirmationTextField: UITextField!
    @IBOutlet weak var warningLable: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextField.placeholder = "Логин"
        loginTextField.keyboardType = UIKeyboardType.emailAddress
        loginTextField.returnKeyType = .next
        
        passwodTextField.placeholder = "Пароль"
        passwodTextField.isSecureTextEntry = true
        passwodTextField.returnKeyType = .next
        
        passwordcCnfirmationTextField.placeholder = "Подтверждение пароля"
        passwordcCnfirmationTextField.isSecureTextEntry = true
        passwordcCnfirmationTextField.returnKeyType = .done
        
        warningLable.text = ""
        warningLable.textColor = .red
        
        let notificationCenter = NotificationCenter.default
               notificationCenter.addObserver(self,
                                              selector: #selector(adjustForKeyboard),
                                              name: UIResponder.keyboardWillHideNotification,
                                              object: nil)
               
               notificationCenter.addObserver(self,
                                              selector: #selector(adjustForKeyboard),
                                              name: UIResponder.keyboardWillChangeFrameNotification,
                                              object: nil)
    }
    
    // MARK: - Work with keyboard
       
       @objc func adjustForKeyboard(notification: Notification) { // реализация скролла во время открытой клавиатуры
           guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

           let keyboardScreenEndFrame = keyboardValue.cgRectValue
           let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

           if notification.name == UIResponder.keyboardWillHideNotification { // после завершения
               scrollView.contentInset = .zero
           } else {
               scrollView.contentInset = UIEdgeInsets(top: 0,
                                                      left: 0,
                                                      bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                                                      right: 0)
           }

           scrollView.scrollIndicatorInsets = scrollView.contentInset

       }
    
    // MARK: - Register with email

    @IBAction func registerTapped(_ sender: UIButton) {
        
        guard passwodTextField.text == passwordcCnfirmationTextField.text else { warningLable.text = "Пароли не совпадают"; return }
        guard let email = loginTextField.text, let password = passwodTextField.text, email != "", password != "" else {
            if (passwodTextField.text!.count < 8 ){
                warningLable.text = "Пароль должен содержать больше 8 символов и цифр"
            } else {
                warningLable.text =  "Info is incorrect"
            }
                return
            }
        
            Auth.auth().createUser(withEmail: email, password: password) {[weak self] (user, error) in
                   if error == nil {
                       if user != nil {
                           self?.performSegue(withIdentifier: "registerSegue", sender: nil)
                       }
                    else {
                    self?.warningLable.text = "Пользователь с таким логином уже существует"
                    }
                   }
                   else {
                self?.warningLable.text = "Error"
            }
        }
    }
}

// MARK: Text field delegate

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginTextField {
            passwodTextField.becomeFirstResponder()
        }
        if textField == self.passwodTextField {
            passwordcCnfirmationTextField.becomeFirstResponder()
        }
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        return true
    }
}
