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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func agreeButtonTapped(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if(!CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == .denied){
            let alert = UIAlertController(title: "Location Not Enabled", message: "You have not allowed the A2D2 app to access your GPS location. Without this permission this app cannot function. Please go to you settings and enable the GPS permission", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            performSegue(withIdentifier: "seque_Request_Ride_Page", sender: self)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            performSegue(withIdentifier: "seque_Request_Ride_Page", sender: self)
        case .denied:
            let alert = UIAlertController(title: "Location Not Enabled", message: "You have not allowed the A2D2 app to access your GPS location. Without this permission this app cannot function. Please go to you settings and enable the GPS permission", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        default:
            return
        }
    }
}
