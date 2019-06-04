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
            notify("Please fill out both boxes");
        } else if (email != emailConfirm) {
            notify("Emails do not match")
        } else {
            AuthenticationUtils.isRegisteredUserEmail(email: email) { (isRegistered) in
                if isRegistered {
                    AuthenticationUtils.requestPasswordReset(forEmail: email)
                    self.notify("Email Sent")
                } else {
                    self.notify("Email not Registered")
                }
            }
        }
    }
    
    
    func notify(_ message:String){
        let nilNameAlert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        nilNameAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(nilNameAlert, animated: true)
    }
}
