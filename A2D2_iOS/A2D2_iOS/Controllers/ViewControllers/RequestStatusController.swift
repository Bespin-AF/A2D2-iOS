//
//  RequestStatusController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/16/19.
//  Copyright © 2019 Bespin. All rights reserved.
//
// NOTE: May break sections into an enum later for cleanliness
//

import UIKit


class RequestStatusController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 20
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! RequestStatusCell
        var status = getSectionFromInt(indexPath.section)
        if(status == "N/A") {status = ""}
        let section = DataSourceUtils.getCurrentRequestsWhere(column: "status", equals: status)
        let rideRequest = section[indexPath.row]
        cell.statusLabel.text = getDetailDescription(rideRequest, "status")
        cell.detailLabel.text = getDetailDescription(rideRequest, "gender")
        cell.timeLabel.text = getDetailDescription(rideRequest, "timestamp")
        return cell
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.getSectionFromInt(section)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var status = getSectionFromInt(section)
        if(status == "N/A") {status = ""}
        
        return  DataSourceUtils.getCurrentRequestsWhere(column: "status", equals: status).count
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    private func getDetailDescription(_ rideRequest : [String : Any],_ detail : String ) -> String{
        return "\(rideRequest[detail] ?? "[N/A]")"
    }
    
    
    private func getSectionFromInt(_ section : Int) -> String {
        switch section {
        case 0:
            return "Available"
        case 1:
            return "In Progress"
        case 2:
            return "Completed"
        default:
            return "N/A"
        }
    }
    
    @objc private func refresh(_ sender : Any){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
    }
}
