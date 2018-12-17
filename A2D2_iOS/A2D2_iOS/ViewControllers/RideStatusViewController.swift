//
//  RideStatusViewController.swift
//  A2D2_iOS
//
//  Created by Joseph Mills on 12/14/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import Foundation
import UIKit
import CallKit

class RideStatusViewController: UIViewController {
    let callController = CXCallController()
    
    @IBAction func callA2D2() {
        let uuid = UUID()
        let handle = CXHandle(type: .phoneNumber, value: "8503561450")
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        let transaction = CXTransaction(action: startCallAction)
        callController.request(transaction) { error in
            if let error = error {
                print("Error requesting transaction: \(error)")
            } else {
                print("Requested transaction successfully")
            }
        }
    }
}
