//
//  DriverLoginController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/15/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit


class DriverLoginController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var dismissKeyboardTap: UITapGestureRecognizer!
    @IBOutlet var dismissKeyboardSwipe: UISwipeGestureRecognizer!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: MyButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        if (emailTextField.text == "" || passwordTextField.text == "") {
            notify("Username and Password are Required")
            return
        }
        AuthenticationUtils.login(email: emailTextField.text!, password: passwordTextField.text!) { (validLogin) -> () in
            self.notifyLoginAttempt(result: validLogin)
        }
    }
    
    
    func notifyLoginAttempt(result wasValid: Bool){
        if wasValid {
            self.performSegue(withIdentifier: "ride_requests", sender: self)
        } else {
            notify("The email or password you entered was incorrect. Please try again.")
        }
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func swipeHandler (_ sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            view.endEditing(true)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButton.sendActions(for: .touchUpInside)
        }
        return false
    }
    
    
    func notify(_ message:String){
        let nilNameAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        nilNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(nilNameAlert, animated: true)
    }
}
