//
//  InputViewController.swift
//  RandomizerWithCoreData
//
//  Created by Rotach Roman on 26.04.2020.
//  Copyright © 2020 Roman. All rights reserved.
//

import UIKit
import Firebase
import Locksmith

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextFieldOutlet: UITextField!{
    didSet {
        loginTextFieldOutlet.tintColor = UIColor.lightGray
        loginTextFieldOutlet.setIcon(UIImage(named: "people")!)
        loginTextFieldOutlet.alpha = 0.49
           }
    }
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField! {
        didSet {
            passwordTextFieldOutlet.tintColor = UIColor.lightGray
            passwordTextFieldOutlet.setIcon(UIImage(named: "lock")!)
            passwordTextFieldOutlet.alpha = 0.45
        }
    }
    @IBOutlet weak var warningLabel: UILabel!
    
    
     // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginTextFieldOutlet.placeholder = "Логин"
        loginTextFieldOutlet.keyboardType = UIKeyboardType.emailAddress
        loginTextFieldOutlet.clearButtonMode = .whileEditing
        loginTextFieldOutlet.returnKeyType = .next
        
        passwordTextFieldOutlet.placeholder = "Пароль"
        passwordTextFieldOutlet.keyboardType = UIKeyboardType.default
        passwordTextFieldOutlet.isSecureTextEntry = true
        passwordTextFieldOutlet.clearButtonMode = .whileEditing
        passwordTextFieldOutlet.returnKeyType = .done
        
        warningLabel.text = "Введиите логин и пароль"
        
        navigationController?.isNavigationBarHidden = true
        
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "MyAccount")
               if dictionary != nil {
                   if !dictionary!.isEmpty {
                    performSegue(withIdentifier: "startSegue", sender: nil)
                    
                }
            }
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
    
    // MARK: - Login with email
    
    @IBAction func enterTapped(_ sender: UIButton) {
        guard let email = loginTextFieldOutlet.text, let password = passwordTextFieldOutlet.text, email != "", password != "" else { warningLabel.text = "Введен не верно логин или пароль"
            warningLabel.textColor = .red
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {[weak self] (user, error) in
            if error != nil {
                self?.warningLabel.text = "Error"
                self?.warningLabel.textColor = .red
                print(error as Any)
                return
            }
            
            if user != nil {
                self?.saveLoginWithPasswod(email: email, password: password)
                self?.performSegue(withIdentifier: "startSegue", sender: nil)
                return
            }
            
            self?.warningLabel.text = "Нет пользователя с логином \(String(describing: self?.loginTextFieldOutlet.text))"
            self?.warningLabel.textColor = .red
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//        self.scrollView.endEditing(true)
//    }
    // MARK: - Save login and passwod
    func saveLoginWithPasswod (email: String, password: String) {
        do {
            try Locksmith.saveData(data: ["Login" : email, "Password" : password], forUserAccount: "MyAccount" )
        } catch {
            self.warningLabel.textColor = .red
            self.warningLabel.text = "При следующем запуске вам возможно нужно будет снова ввести логин и пароль"
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                sleep(1)
            })
        }
    }
}
// MARK: - Extension  UITextField
extension UITextField {
func setIcon(_ image: UIImage) { 
   let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
    iconView.image = image
   let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
   iconContainerView.addSubview(iconView)
   leftView = iconContainerView
   leftViewMode = .always
}
}


// MARK: Text field delegate

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginTextFieldOutlet {
            passwordTextFieldOutlet.becomeFirstResponder()
        }
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        return true
    }
}
