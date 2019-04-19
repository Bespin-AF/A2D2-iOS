//
//  Rider_RequestStatusController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/23/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit

class Rider_RequestStatusController: UIViewController, DataSourceDelegate {
   
    @IBOutlet weak var callButton: MyButton!
    var request : Request!
    var a2d2Number : String!
    let requestDataSource = DataSource(.Requests)
    let resourceDataSource = DataSource(.Resources)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callButton.isEnabled = false
        resourceDataSource.delegate = self
    }
    
    
    func dataSource(_ dataSource: DataSource, dataValues: [String : Any]) {
        a2d2Number = dataValues["a2d2phonenumber"] as? String
        callButton.isEnabled = true
    }
    
    
    @IBAction func callA2D2() {
        SystemUtils.call(number: a2d2Number)
    }
    
    @IBAction func cancelRide() {
        let alert = UIAlertController(title: "Confirm Cancellation", message: "Are you sure you want to cancel your ride request?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler:{action in
            self.cancelActions()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func cancelActions(){
        self.request.status = .Cancelled
        requestDataSource.update(key: request.key! ,data: request.requestData)
        let alert = UIAlertController(title: "Cancelled", message: "Your request was cancelled successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {action in
            self.performSegue(withIdentifier: "return_home_after_cancel", sender: self)
        }))
        self.present(alert, animated: true)
    }
}
