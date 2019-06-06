//
//  RideRequestTableView.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 6/5/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit


class RideRequestTableView : UITableView, UITableViewDataSource, DataSourceDelegate{
    var requestType : Status! = Status.Available
    var requests : [Request]!
    
    
    func prepareForDispay(){
        DataSourceUtils.requests.delegate = self;
    }
    
    
    func setRequestFilter(_ filter : Status){
        requestType = filter
        reloadData()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 65
        sectionHeaderHeight = UITableView.automaticDimension
        estimatedSectionHeaderHeight = 20
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let status = getStatusFromSection(section)
        let statusString = getStatusString(status)
        return  getRequestsWhere(column: "status", equals: statusString).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    
    // Returns data for section containing the IndexPath
    private func getSectionData(forIndex index: IndexPath) -> [Request] {
        //Resolve section based on index
        let status = getStatusFromSection(index.section)
        let statusString = getStatusString(status)
        return getRequestsWhere(column: "status", equals: statusString)
    }
    
    
    private func getRequestsWhere(column: String,equals value: String) -> [Request]{
        var results = [Request]()
        
        if requests == nil {return results}
        
        for  request : Request in self.requests! {
            if request.requestData[column] as! String == value {
                results.append(request)
            }
        }
        
        return results
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
    
    
    // Returns a human-readable description for a given detail of a ride request
    private func getDetailDescription(_ rideRequest : Request,_ detail : String ) -> String{
        if(detail == "timestamp"){
            return rideRequest.formattedTimestamp
        }
        return "\(rideRequest.requestData[detail] ?? "N/A")"
    }
    

    // Applies special formatting to cells
    private func specialFormatCell( cell : inout RequestStatusCell, request : Request){
        if request.status == Status.InProgress{
            cell.backgroundColor = cell.takenRequestColor
        } else if request.status == Status.Completed {
            cell.backgroundColor = cell.completedRequestColor
        }
    }
    
    
    func dataSource(_ dataSource: DataSource, dataValues: [String : Any]) {
        updateRequestsFromDataSource(data: dataValues)
    }
    
    
    func updateRequestsFromDataSource(data: [String : Any]){
        requests = DataSourceUtils.requestsFromData(data)
        refresh(self)
    }
    
    
    @objc private func refresh(_ sender : Any){
        self.dataSource = self
        self.reloadData()
        self.refreshControl!.endRefreshing()
    }
}
