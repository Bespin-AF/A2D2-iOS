//
//  RulesController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 11/16/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit
import CoreLocation

class RulesController: UIViewController {
    let locationManager = CLLocationManager()
    @IBOutlet var acknowledgeRulesButton: MyButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func acknowledgeRulesButtonTapped(_ sender: Any) {
        locationManager.requestAlwaysAuthorization()
    }
    
}
