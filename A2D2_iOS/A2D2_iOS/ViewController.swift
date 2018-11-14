//
//  ViewController.swift
//  A2D2_iOS
//
//  Created by Justin Godsey on 11/13/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var requestRideButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        requestRideButton.layer.cornerRadius = 15
        
    }
    
    @IBAction func requestRideButtonPressed(sender: AnyObject) {
        
    }
    
}

