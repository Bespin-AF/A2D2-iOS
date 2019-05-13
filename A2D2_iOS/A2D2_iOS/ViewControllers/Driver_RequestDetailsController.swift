//
//  Driver_RequestDetailsController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/23/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Foundation
import UIKit

class Driver_RequestDetailsController: UIViewController {
    @IBOutlet weak var jobActionButton: MyButton!
    @IBOutlet weak var textRiderButton: MyButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    let dataSource = DataSource(.requests)
    var request: Request!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        populateRequestInfo()
        updateActionButton()
        updateEnabledButtons()
    }
    
    
    private func populateRequestInfo() {
        statusLabel.text = "\(getStatusString(request.status))"
        groupSizeLabel.text = "\(request.groupSize)"
        nameLabel.text = "\(request.name)"
        genderLabel.text = "\(request.gender)"
        phoneNumberLabel.text = "\(request.phone)"
        commentsLabel.text = "\(request.remarks)"
    }
    
    
    private func updateActionButton() {
        if request.status == .inProgress &&
            request.driver == AuthenticationUtils.currentUser?.uid ?? "Default" {
            jobActionButton.setTitle("Complete Job", for: .normal)
        } else {
            jobActionButton.setTitle("Take Job", for: .normal)
        }
    }
    
    
    private func updateEnabledButtons() {
        if request.status == .completed {
            jobActionButton.isEnabled = false
            textRiderButton.isEnabled = false
        } else {
            jobActionButton.isEnabled = true
            textRiderButton.isEnabled = true
        }
    }
    
    
    @IBAction func textRider(_ sender: Any) {
        let number = request.phone
        let message = "Hey this is your A2D2 driver."
        SystemUtils.text(number: number, message: message)
    }
    
    
    @IBAction func jobActionTapped(_ sender: Any) {
        if request.status == .inProgress && request.driver == AuthenticationUtils.currentUser?.uid {
            confirmCompleteJob()
        } else {
            confirmTakeJob()
        }
    }
    
    
    func confirmTakeJob() {
        let alertTitle = hasJobBeenPreviouslyAccepted() ? "Confirm Pickup" : "Job Previously Accepted"
        let alert = UIAlertController(title: alertTitle, message: "Are you sure you want to pick up this rider?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in self.takeJobActions()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func takeJobActions() {
        let lat = request.lat
        let lon = request.lon
        updateStatus(.inProgress)
        openMaps(lat, lon)
    }
    
    
    func confirmCompleteJob() {
        let alert = UIAlertController(title: "Confirm Dropoff", message: "This job has ben successfully completed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {_ in self.completeJobActions()}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func completeJobActions() {
        updateStatus(.completed)
        navigationController?.popViewController(animated: true)
    }
    
    
    func openMaps(_ lat: Double, _ lon: Double) {
        SystemUtils.map(lat: lat, lon: lon)
    }
    
    
    func updateStatus(_ status: Status) {
        request.status = status
        request.driver = AuthenticationUtils.currentUser?.uid ?? "Default"
        dataSource.update(key: request.key!, data: request.requestData)
    }
    
    
    func hasJobBeenPreviouslyAccepted() -> Bool {
        return request.status == Status.available
    }
}
