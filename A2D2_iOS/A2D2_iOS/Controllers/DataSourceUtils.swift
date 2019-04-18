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

class DataSourceUtils{
    static var ref = Database.database().reference()
    static var requests : [Request] = []
    static var resources : [String : String] = [:]
    static var readInFormatter = DateFormatter()
    static var outputFormatter = DateFormatter()
    static private let requestTable = "test_requests" // Firebase Table
    
    // Initializes firebase functionality
    public static func initFirebase(){
        FirebaseApp.configure()
    }
    
    
    public static func initDateFormatters(){
        readInFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        outputFormatter.dateFormat = "MMM dd, HH:mm"
    }

    
    // Sends new data to the data source
    public static func sendData(data : Request){
        data.key = ref.child(requestTable).childByAutoId().key!
        updateData(data: data)
    }
    
    
    // Updates an existing entry in the data source
    public static func updateData(data: Request){
        guard data.key != nil else {
            sendData(data: data)
            return
        }
        ref.child(requestTable).child(data.key!).setValue(data.requestData)
    }
    
    
    public static func removeData(key: String){
        ref.child(requestTable).child(key).removeValue()
    }
 
    
    public static func convertToMeters(miles : Double) -> Double{
        return miles * 1609.344 // Exact number of meters in a mile
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
}
