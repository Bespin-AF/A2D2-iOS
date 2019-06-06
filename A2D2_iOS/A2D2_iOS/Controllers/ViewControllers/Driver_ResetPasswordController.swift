//
//  Driver_ResetPasswordController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 5/28/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit

class Driver_ResetPasswordController: UIViewController {
    @IBOutlet weak var confirmEmailTextBox: UITextField!
    @IBOutlet weak var emailTextBox: UITextField!
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "return_to_login", sender: self)
    }
    
    
    @IBAction func sendLinkButtonTapped(_ sender: Any) {
        let email = emailTextBox.text!
        let emailConfirm = confirmEmailTextBox.text!
        
        if (email == "" || emailConfirm == ""){
            notify(title: "",message: "Please fill out both boxes");
        } else if (email != emailConfirm) {
            notify(title: "", message: "Emails do not match")
        } else {
            AuthenticationUtils.isRegisteredUserEmail(email: email) { (isRegistered) in
                if isRegistered {
                    AuthenticationUtils.requestPasswordReset(forEmail: email)
                }
                self.notify(title: "Message Sent",message: "Check following email for instructions: \(email)")
            }
        }
    }
    
    
    func notify(title : String, message : String){
        let nilNameAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        nilNameAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(nilNameAlert, animated: true)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @IBAction func swipeHandler (_ sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            view.endEditing(true)
        }
    }
    
}
