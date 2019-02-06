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
    @IBOutlet weak var jobActionButton: MyButton!
    @IBOutlet weak var textRiderButton: MyButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    var requestData : Request!
    var requestKey : String!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        populateRequestInfo()
        updateActionButton()
        updateEnabledButtons()
    }
    
    
    private func populateRequestInfo(){
        statusLabel.text = "\(getStatusString(requestData.status))"
        groupSizeLabel.text = "\(requestData.groupSize)"
        nameLabel.text = "\(requestData.name)"
        phoneNumberLabel.text = "\(requestData.phone)"
        commentsLabel.text = "\(requestData.remarks)"
    }
    
    
    private func updateActionButton(){
        if (requestData.status == .InProgress &&
            requestData.driver == AuthenticationUtils.currentUser!?.uid ?? "Default") {
            jobActionButton.setTitle("Complete Job", for: .normal)
        } else {
            jobActionButton.setTitle("Take Job", for: .normal)
        }
    }
    
    
    private func updateEnabledButtons(){
        if(requestData.status == .Completed){
            jobActionButton.isEnabled = false
            textRiderButton.isEnabled = false
        } else {
            jobActionButton.isEnabled = true
            textRiderButton.isEnabled = true
        }
    }
    
    
    @IBAction func textRider(_ sender: Any) {
        let number = requestData.phone
        let message = "Hey this is your A2D2 driver."
        SystemUtils.text(number: number, message: message)
    }
    
    
    @IBAction func jobActionTapped(_ sender: Any) {
        if(requestData.status == .InProgress && requestData.driver == AuthenticationUtils.currentUser!?.uid){
            confirmCompleteJob()
        } else {
            confirmTakeJob()
        }
    }
    
    
    func confirmTakeJob() {
        let alertTitle = requestData.status == Status.InProgress ? "Confirm Pickup" : "Job Previously Accepted"
        let alert = UIAlertController(title: alertTitle, message: "Are you sure you want to pick up this rider?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {action in self.takeJobActions()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func takeJobActions(){
        let lat = requestData.lat
        let lon = requestData.lon
        updateStatus(.InProgress)
        openMaps(lat, lon)
    }
    
    
    func confirmCompleteJob() {
        let alert = UIAlertController(title: "Confirm Dropoff", message: "This job has ben successfully completed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {action in self.completeJobActions()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func completeJobActions(){
        updateStatus(.Completed)
        navigationController?.popViewController(animated: true)
    }
    
    
    func openMaps(_ lat: Double,_ lon: Double) {
        SystemUtils.map(lat: lat, lon: lon)
    }
    
    
    func updateStatus(_ status : Status) {
        requestData.status = status
        requestData.driver = AuthenticationUtils.currentUser!?.uid ?? "Default"
        DataSourceUtils.updateData(data: requestData, key: requestKey)
    }
}
