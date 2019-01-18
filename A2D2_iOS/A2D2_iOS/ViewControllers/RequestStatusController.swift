//
//  RequestStatusController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/16/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit


class RequestStatusController: UITableViewController {

    var requestList : [[String : Any]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        addItem()
    }
    
    
    func addItem() {
        requestList[0] = ["status" : "Available",
                          "groupSize" : 1,
                          "gender" : "male",
                          "timestamp" : Date().description]
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! RequestStatusCell
        let rideRequest = requestList[indexPath.row]
        cell.statusLabel.text = getDetailDescription(rideRequest, "status")
        cell.detailLabel.text = getDetailDescription(rideRequest, "gender")
        cell.timeLabel.text = getDetailDescription(rideRequest, "timestamp")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func getDetailDescription(_ rideRequest : [String : Any],_ detail : String ) -> String{
        return "\(rideRequest[detail] ?? "[N/A]")"
    }
}
