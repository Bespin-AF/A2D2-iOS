//
//  RulesViewcontroller.swift
//  A2D2_iOS
//
//  Created by Justin Godsey on 11/20/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class RulesViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var agreeButton: MyButton!
    var locationManager = CLLocationManager()
    var didTapButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    
    @IBAction func agreeButtonTapped(){
        checkLocation()
        didTapButton = true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(didTapButton){
            checkLocation()
            didTapButton = false
        }
    }
    
    
    func checkLocation(){
        locationManager.requestWhenInUseAuthorization()
        if(!CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .denied){
            let alert = UIAlertController(title: "Location Not Enabled", message: "You have not allowed the A2D2 app to access your GPS location. Without this permission this app cannot function. Please go to you settings and enable the GPS permission", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else if(CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
            performSegue(withIdentifier: "seque_Request_Ride_Page", sender: self)
        }
    }
}
