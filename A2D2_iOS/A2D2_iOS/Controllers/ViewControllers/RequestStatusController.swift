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
    
    
    // Gives TableView populated cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestStatusCell
        let rideRequest = getRequestData(atIndex: indexPath)
        fillCellWithRequestData(cell: &cell, request: rideRequest)
        return cell
    }
    
    
    // Returns request data for a given IndexPath
    private func getRequestData(atIndex index: IndexPath) -> [String : Any] {
        // Resolve status based on section
        var status = getStatusFromSectionIndex(index.section)
        if(status == "N/A") {status = ""}
        // Query data for all requests within the section (with a matching status)
        let sectionData = DataSourceUtils.getCurrentRequestsWhere(column: "status", equals: status)
        return sectionData[index.row]
    }
    
    
    // Fills a RequestStatusCell with data from a given request
    private func fillCellWithRequestData ( cell :  inout RequestStatusCell, request : [String : Any]){
        cell.statusLabel.text = getDetailDescription(request, "status")
        cell.detailLabel.text = getDetailDescription(request, "gender")
        cell.timeLabel.text = getDetailDescription(request, "timestamp")
    }
    
    
    // Gives TableView the number of sections it has
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    // Gives TableView titles for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.getStatusFromSectionIndex(section)
    }
    
    
    // Gives TableView the number of rows in a given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var status = getStatusFromSectionIndex(section)
        if(status == "N/A") {status = ""}
        
        return  DataSourceUtils.getCurrentRequestsWhere(column: "status", equals: status).count
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // NOTE: Assumes only segue is to the detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! RideRequestDetailsController
        detailView.requestData = getRequestData(atIndex: tableView.indexPathForSelectedRow!)
    }

    
    // Returns a human-readable description for a given detail of a ride request
    private func getDetailDescription(_ rideRequest : [String : Any],_ detail : String ) -> String{
        return "\(rideRequest[detail] ?? "[N/A]")"
    }
    
    
    private func getStatusFromSectionIndex(_ section : Int) -> String {
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
