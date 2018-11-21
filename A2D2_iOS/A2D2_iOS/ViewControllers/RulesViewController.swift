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
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            performSegue(withIdentifier: "seque_Request_Ride_Page", sender: self)
        case .denied:
            let alert = UIAlertController(title: "Permissions Alert", message: "Need to turn on Permissions.", preferredStyle: .alert)
            self.present(alert, animated: true)
        default:
            return
        }
    }
}
