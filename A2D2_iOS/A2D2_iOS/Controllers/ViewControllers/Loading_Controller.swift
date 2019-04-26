//
//  Loading_Controller.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 4/24/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class Loading_Controller : UIViewController, DataSourceDelegate {
    
    @IBOutlet weak var spinnyBoi: UIActivityIndicatorView!
    var didGetResources = false
    var didGetRequests = false
    
    override func viewDidLoad() {
        DataSourceUtils.resources.delegate = self
        DataSourceUtils.requests.delegate = self
        
        spinnyBoi.startAnimating()
    }
    
    
    func dataSource(_ dataSource: DataSource, dataValues: [String : Any]) {
        if dataSource === DataSourceUtils.resources {
            didGetResources = true
        } else if dataSource === DataSourceUtils.requests {
            didGetRequests = true
        }
        
        if didGetRequests && didGetResources {
            self.performSegue(withIdentifier: "segue_show_home", sender: self)
        }
    }
}
