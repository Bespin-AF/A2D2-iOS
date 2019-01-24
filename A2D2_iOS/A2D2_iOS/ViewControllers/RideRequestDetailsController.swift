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
        let number = "123456789"
        let text = "test%20message%20for%20rider"//Manually encoded as URI
        let url = URL(string: "sms://+\(number)/&body=\(text)")!
        UIApplication.shared.open(url)
    }
}
