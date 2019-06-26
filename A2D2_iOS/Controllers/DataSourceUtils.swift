//
//  DataSourceUtils.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/18/19.
//  Copyright © 2019 Bespin. All rights reserved.
//
// I'm isolating the firebase specific code for cleanliness as well as
// allowing for another data storage solution to be easily substituted
// in the future for practice / training or migration.
//

import Firebase
import CoreLocation
import FirebaseFunctions

class DataSourceUtils{
    static var readInFormatter = DateFormatter()
    static var outputFormatter = DateFormatter()
    static var a2d2Base : String? {
        didSet {
            resources.initDataSourceConnection()
            requests.initDataSourceConnection()
            locations.initDataSourceConnection()
        }
    }
    static let resources = DataSource(.BaseInfo)
    static let requests = DataSource(.TestRequests)
    static let locations = DataSource(.BaseLocation)
    

    // Initializes firebase functionality
    public static func initFirebase(){
        FirebaseApp.configure()
    }
    
    
    public static func initDateFormatters(){
        readInFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        outputFormatter.dateFormat = "MMM dd, HH:mm"
    }

    
    public static func resolveA2D2Base(location : CLLocation, _ completion : ((_ : Bool)->())? = nil) {
        let locationString = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        Functions.functions().httpsCallable("closest").call(locationString, completion: { (response, error) in
            var didResolve = false
            a2d2Base = response?.data as? String
            if (a2d2Base != nil) {
                didResolve = true
            }
            if(completion != nil){
                completion!(didResolve)
            }
        })
    }

    
    public static func convertToMeters(miles : Double) -> Double{
        return miles * 1609.344 // Meters in a mile
    }
    
    
    public static func getLocationFromString(_ locationString : String) -> CLLocation{
        guard locationString.contains(",") else {
            return CLLocation(latitude: 0, longitude: 0)
        }
        
        let latLon = locationString.split(separator: ",")
        let lat = Double(latLon[0])
        let lon = Double(latLon[1])
        return CLLocation(latitude: lat!, longitude: lon!)
    }
    
    
    public static func requestsFromData(_ data : [String:Any]) -> [Request]{
        var requests = [Request]()
        for row in data {
            let requestData = row.value as? NSDictionary
            if requestData == nil { continue }
            let requestKey = row.key
            let request = Request(requestData as! Dictionary<String, Any>)
            request.key = requestKey
            requests.append(request)
        }
        return requests
    }
}
