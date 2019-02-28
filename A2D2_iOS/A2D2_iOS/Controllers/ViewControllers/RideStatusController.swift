//
//  RideStatusController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/23/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Foundation
import UIKit

class RideStatusViewController: UIViewController {
    
    @IBAction func callA2D2() {
        let number = DataSourceUtils.getResource(key: "a2d2phonenumber")
        SystemUtils.call(number: number)
    }
}
