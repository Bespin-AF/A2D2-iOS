//
//  Rider_RulesController.swift
//  A2D2_iOS
//
//  Created by Justin Godsey on 11/20/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class Rider_RulesController: UIViewController, CLLocationManagerDelegate, DataSourceDelegate{

    @IBOutlet var agreeButton: MyButton!
    var locationManager = CLLocationManager()
    var didAgreeToRules = false
    var baseLocationString : String!
    var a2d2Number : String!


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        agreeButton.isEnabled = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataSourceUtils.resources.delegate = self
    }
    
    
    func dataSource(_ dataSource: DataSource, dataValues: [String : Any]) {
        baseLocationString = (dataValues["base_location"] as! String)
        a2d2Number = (dataValues["phone_number"] as! String)
        agreeButton.isEnabled = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        didAgreeToRules = false
    }
    
    
    @IBAction func agreeButtonTapped() {
        didAgreeToRules = true
        checkLocationPermissions()
    }

    
    func checkLocationPermissions() {
        if(CLLocationManager.authorizationStatus() == .notDetermined ) {
            locationManager.requestWhenInUseAuthorization()
        } else if didDenyLocationPermission() {
            alertNoLocationPermissions()
        } else if hasLocationPermissions() {
            locationManager.requestLocation() // TODO: Add Spinny Boi Here
            //Location range check is done in the delegate function 'didUpdatelocations'
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if hasLocationPermissions() && didAgreeToRules {
            locationManager.requestLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if didAgreeToRules {
            let mostCurrentLocation = locations.last!
            checkLocation(location: mostCurrentLocation)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error updating location: \(error)")
    }
    
    
    func hasLocationPermissions() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    
    func didDenyLocationPermission() -> Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    
    
    func checkLocation(location : CLLocation) {
        if isWithinRange(location: location) {
            proceedToRequestPage()
        } else {
            alertOutOfRange()
        }
    }
    
    
    func isWithinRange(location: CLLocation) -> Bool {
        let baseLocation = DataSourceUtils.getLocationFromString(baseLocationString)
        let distance = location.distance(from: baseLocation)
        let allowedRange = DataSourceUtils.convertToMeters(miles: 25)
        return distance <= allowedRange
    }
    
    
    func proceedToRequestPage() {
        performSegue(withIdentifier: "seque_Request_Ride_Page", sender: self)
    }
    
    
    func alertNoLocationPermissions() {
        let alert = UIAlertController(title: "Location Not Enabled", message: "You have not allowed the A2D2 app to access your GPS location. Without this permission this app cannot function. Please go to you settings and enable the GPS permission", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func alertOutOfRange() {
        let alert = UIAlertController(title: "Location out of range!", message: "You are outside of the 25 mile range defined by the A2D2 program rules. If you still require a ride, please call A2D2 Dispatch at 334-953-3913", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Call", style: .default, handler:{ action in
            self.callA2D2()
        }))
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func callA2D2() {
        SystemUtils.call(number: a2d2Number)
    }
}
