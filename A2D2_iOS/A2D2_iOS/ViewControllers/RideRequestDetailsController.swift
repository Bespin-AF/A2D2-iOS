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
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    var requestData : Request!
    var requestKey : String!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        statusLabel.text = "\(requestData.status)"
        groupSizeLabel.text = "\(requestData.groupSize)"
        nameLabel.text = "\(requestData.name)"
        phoneNumberLabel.text = "\(requestData.phone)"
        commentsLabel.text = "\(requestData.remarks)"
    }
    
    
    @IBAction func textRider(_ sender: Any) {
        let number = requestData.phone
        let message = "Hey this is your A2D2 driver."
        SystemUtils.text(number: number, message: message)
    }
    
    
    @IBAction func takeJob(_ sender: Any) {
        var alertTitle = "Confirm Pickup"
        let lat = requestData.lat
        let lon = requestData.lon
        if(requestData.status == Status.InProgress){
            alertTitle = "Job Previously Accepted"
        }
        let alert = UIAlertController(title: alertTitle, message: "Are you sure you want to pick up this rider?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {action in self.openMaps(lat, lon); self.updateStatus()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func openMaps(_ lat: Double,_ lon: Double) {
        SystemUtils.map(lat: lat, lon: lon)
    }
    
    
    func updateStatus() {
        requestData.status = Status.InProgress
        DataSourceUtils.updateData(data: requestData, key: requestKey)
    }
}
