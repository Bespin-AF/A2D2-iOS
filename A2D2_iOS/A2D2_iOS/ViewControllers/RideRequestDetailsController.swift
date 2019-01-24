//
//  RideRequestDetailsController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/23/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Foundation
import UIKit

class RideRequestDetailsController: UIViewController {
    
    @IBAction func textRider(_ sender: Any) {
        //[[UIApplication textRider ] openURL:@sms:"555555555"]
        let number = "123456789"
        let text = "test message for rider"
        let url = URL(string: "sms://\(number);body=\(number)")!
        UIApplication.shared.open(url)
    }
}


