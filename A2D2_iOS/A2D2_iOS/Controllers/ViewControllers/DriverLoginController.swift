//
//  DriverLoginController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/15/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit


class DriverLoginController: UIViewController{
    
    @IBOutlet var DismissKeyboardTap: UITapGestureRecognizer!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        if (EmailTextField.text == "" || PasswordTextField.text == "") {
            notify("Username and Password are Required")
            return
        }
        self.performSegue(withIdentifier: "ride_requests", sender: self)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func notify(_ message:String){
        let nilNameAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        nilNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(nilNameAlert, animated: true)
    }
}
