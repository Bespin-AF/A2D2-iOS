//
//  Request.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/29/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Foundation

class Request : Comparable{
    
    static func < (lhs: Request, rhs: Request) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
    
    static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.lat == rhs.lat && lhs.lon == rhs.lon
    }
    
    var requestData : [String: Any] = [:]
    
    var status : Status {
        get {
            let statusString = requestData["status"] as! String? ?? ""
            return  resolveStatus(fromString: statusString)
        }
        set { requestData["status"] = getStatusString(newValue)}
    }
    
    var gender : String {
        get { return requestData["gender"] as! String? ?? ""}
        set { requestData["gender"] = newValue}
    }
    
    var groupSize : Int {
        get { return requestData["groupSize"] as! Int? ?? 0}
        set { requestData["groupSize"] = newValue}
    }
    
    var remarks : String {
        get { return requestData["remarks"] as! String? ?? ""}
        set { requestData["remarks"] = newValue}
    }
    
    var lat : Double {
        get { return requestData["lat"] as! Double? ?? 0}
        set { requestData["lat"] = newValue}
    }
    
    var lon : Double {
        get { return requestData["lon"] as! Double? ?? 0}
        set { requestData["lon"] = newValue}
    }
    
    var name : String {
        get { return requestData["name"] as! String? ?? ""}
        set { requestData["name"] = newValue}
    }
    
    var phone : String {
        get { return requestData["phone"] as! String? ?? ""}
        set { requestData["phone"] = newValue}
    }
    
    var timestamp : Date {
        get {
            let dateString = requestData["timestamp"] as! String
            return DataSourceUtils.readInFormatter.date(from: dateString) ?? Date()}
        set { requestData["timestamp"] = newValue.description}
    }
    
    var driver : String? {
        get { return requestData["driver"] as? String}
        set { requestData["driver"] = newValue}
    }
    
    var formattedTimestamp : String {
        get { return DataSourceUtils.outputFormatter.string(from: self.timestamp) }
    }
}
