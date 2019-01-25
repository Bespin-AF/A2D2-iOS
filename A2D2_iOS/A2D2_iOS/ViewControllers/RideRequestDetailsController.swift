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
    
    var requestData : [String : Any]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        statusLabel.text = "\(requestData["status"] ?? "N/A")"
        groupSizeLabel.text = "\(requestData["groupSize"] ?? "N/A")"
        nameLabel.text = "\(requestData["name"] ?? "N/A")"
        phoneNumberLabel.text = "\(requestData["phone"] ?? "N/A")"
        commentsLabel.text = "\(requestData["remarks"] ?? "N/A")"
    }
    
    @IBAction func textRider(_ sender: Any) {
        let number = "123456789"
        //Percent encoding is required for use in the URL
        let text = "Hey this is your A2D2 rider".addingPercentEncoding(withAllowedCharacters:.alphanumerics)!
        let url = URL(string: "sms://+\(number)/&body=\(text)")!
        UIApplication.shared.open(url)
    }
}
