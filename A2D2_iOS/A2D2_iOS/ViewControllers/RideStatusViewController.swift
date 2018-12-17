//
//  RideStatusViewController.swift
//  A2D2_iOS
//
//  Created by Joseph Mills on 12/14/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import Foundation
import UIKit

class RideStatusViewController: UIViewController {
    
    @IBAction func callA2D2() {
        let number = "3349533913"
        let url = URL(string: "tel://\(number)")!
        UIApplication.shared.open(url)
        
        print(UIApplication.shared.canOpenURL(url))
        
        
        
        
    }
}
