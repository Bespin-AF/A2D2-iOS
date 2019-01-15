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
            return
        }
        self.performSegue(withIdentifier: "ride_requests", sender: self)
    }
    

    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
}
