//
//  Driver_LoginController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/15/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit
import CoreLocation

class Driver_LoginController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate{
    
    @IBOutlet var dismissKeyboardTap: UITapGestureRecognizer!
    @IBOutlet var dismissKeyboardSwipe: UISwipeGestureRecognizer!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: MyButton!
    @IBOutlet weak var loadingEffect: UIVisualEffectView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loadingEffect.isHidden = true
        locationManager.delegate = self
    }
    
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        if (emailTextField.text == "" || passwordTextField.text == "") {
            notify("Username and Password are Required")
            return
        }
        loadingEffect.isHidden = false
        AuthenticationUtils.login(email: emailTextField.text!, password: passwordTextField.text!) { (validLogin) -> () in
            self.notifyLoginAttempt(result: validLogin)
        }
        loadingEffect.isHidden = true
    }
    
    
    func notifyLoginAttempt(result wasValid: Bool){
        if wasValid {
            checkLocationPermissions()
        } else if !SystemUtils.isConnectedToNetwork(){
            SystemUtils.alertNoConnection(self)
        } else {
            notify("The email or password you entered was incorrect. Please try again.")
        }
    }
    
    func checkLocationPermissions() {
        if(CLLocationManager.authorizationStatus() == .notDetermined ) {
            locationManager.requestWhenInUseAuthorization()
        } else if didDenyLocationPermission() {
            alertNoLocationPermissions()
        } else if hasLocationPermissions() {
            locationManager.requestLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if hasLocationPermissions() {
            locationManager.requestLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DataSourceUtils.resolveA2D2Base(location: locations.last!, {(didResolve) -> () in
            if(didResolve && AuthenticationUtils.currentUser != nil){
                self.goToRequestList()
            }
        })
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error)")
    }
    
    
    func goToRequestList() {
        self.performSegue(withIdentifier: "ride_requests", sender: self)
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
    
    
    func hasLocationPermissions() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    
    func didDenyLocationPermission() -> Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    
    
    func notify(_ message:String){
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func alertNoLocationPermissions() {
        let alert = UIAlertController(title: "Location Not Enabled", message: "You have not allowed the A2D2 app to access your GPS location. Without this permission this app cannot function. Please go to you settings and enable the GPS permission", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
