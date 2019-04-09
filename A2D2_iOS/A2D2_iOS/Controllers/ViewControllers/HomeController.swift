//
//  HomeController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 3/29/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit

class HomeController : UIViewController {
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        versionLabel.text = SystemUtils.version()
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
    }
}
