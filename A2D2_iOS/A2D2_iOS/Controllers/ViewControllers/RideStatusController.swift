//
//  RideStatusController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/23/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit

class RideStatusViewController: UIViewController {
    
    var requestData : Request!
    
    @IBAction func callA2D2() {
        let number = DataSourceUtils.getResource(key: "a2d2phonenumber")
        SystemUtils.call(number: number)
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
        self.requestData.status = .Cancelled
        DataSourceUtils.updateData(data: self.requestData)
        let alert = UIAlertController(title: "Cancelled", message: "Your request was cancelled successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {action in
            self.performSegue(withIdentifier: "return_home_after_cancel", sender: self)
        }))
        self.present(alert, animated: true)
    }
}
