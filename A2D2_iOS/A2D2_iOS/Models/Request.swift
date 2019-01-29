//
//  Request.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/29/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Foundation

class Request {
    
    var requestData : [String: Any]!
    
    var status : Status {
        get { return requestData["status"] as! Status}
        set { requestData["status"] = newValue}
    }
    
    var gender : String {
        get { return requestData["gender"] as! String}
        set { requestData["gender"] = newValue}
    }
    
    var groupSize : Int {
        get { return requestData["groupSize"] as! Int}
        set { requestData["groupSize"] = newValue}
    }
    
    var remarks : String {
        get { return requestData["remarks"] as! String}
        set { requestData["remarks"] = newValue}
    }
    
    var lat : String {
        get { return requestData["lat"] as! String}
        set { requestData["lat"] = newValue}
    }
    
    var lon : String {
        get { return requestData["lon"] as! String}
        set { requestData["lon"] = newValue}
    }
    
    var name : String {
        get { return requestData["name"] as! String}
        set { requestData["name"] = newValue}
    }
    
    var phone : String {
        get { return requestData["phone"] as! String}
        set { requestData["phone"] = newValue}
    }
    
    var timestamp : String {
        get { return requestData["timestop"] as! String}
        set { requestData["timestamp"] = newValue}
    }
}




