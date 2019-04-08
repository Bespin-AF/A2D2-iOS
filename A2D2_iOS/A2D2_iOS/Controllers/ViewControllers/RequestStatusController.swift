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
        let rideRequest = getRequest(atIndex: indexPath)
        fillCellWithRequestData(cell: &cell, request: rideRequest)
        if rideRequest.driver == AuthenticationUtils.currentUser!.uid{
            specialFormatCell(cell: &cell, request: rideRequest)
        }  else {
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    
    // Returns request data for a given IndexPath
    private func getRequest(atIndex index: IndexPath) -> Request {
        return getSectionData(forIndex: index).sorted()[index.row]
    }

    
    //NOTE There is likely a better way to manage keys and requests that will make sorting easier.
    // Returns data for section containing the IndexPath
    private func getSectionData(forIndex index: IndexPath) -> [Request] {
        //Resolve section based on index
        let status = getStatusFromSection(index.section)
        let statusString = getStatusString(status)
        return DataSourceUtils.getCurrentRequestsWhere(column: "status", equals: statusString)
    }
    
    
    private func getStatusFromSection(_ section : Int) ->  Status {
        switch section {
        case 0:
            return Status.Available
        case 1:
            return Status.InProgress
        case 2:
            return Status.Completed
        default:
            return Status.Empty
        }
    }
    
    
    // Fills a RequestStatusCell with data from a given request
    private func fillCellWithRequestData ( cell :  inout RequestStatusCell, request : Request){
        cell.statusLabel.text = "Group Size: \(getDetailDescription(request, "groupSize"))"
        cell.detailLabel.text = getDetailDescription(request, "gender")
        cell.timeLabel.text = getDetailDescription(request, "timestamp")
    }
    
    
    // Applies special formatting to cells
    private func specialFormatCell( cell : inout RequestStatusCell, request : Request){
        if request.status == Status.InProgress{
            cell.backgroundColor = cell.takenRequestColor
        } else if request.status == Status.Completed {
            cell.backgroundColor = cell.completedRequestColor
        }
    }
    
    
    // Gives TableView the number of sections it has
    override func numberOfSections(in tableView: UITableView) -> Int {
        return DataSourceUtils.getCurrentRequestsWhere(column: "status", equals: getStatusString(.Empty)).count > 0 ? 4 : 3
    }
    
    
    // Gives TableView titles for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let status = self.getStatusFromSection(section)
        var statusString = getStatusString(status)
        statusString = (statusString == "" ? "N/A" : statusString)
        return statusString
    }
    
    
    // Gives TableView the number of rows in a given section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let status = getStatusFromSection(section)
        let statusString = getStatusString(status)
        return  DataSourceUtils.getCurrentRequestsWhere(column: "status", equals: statusString).count
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // NOTE: Assumes only segue is to the detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView = segue.destination as! RideRequestDetailsController
        let index = tableView.indexPathForSelectedRow!
        detailView.request = getRequest(atIndex: index)
    }

    
    // Returns a human-readable description for a given detail of a ride request
    private func getDetailDescription(_ rideRequest : Request,_ detail : String ) -> String{
        if(detail == "timestamp"){
            return rideRequest.formattedTimestamp
        }
        return "\(rideRequest.requestData[detail] ?? "N/A")"
    }
    
    
    @objc private func refresh(_ sender : Any){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
    }
}
