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
    static var requests : [String : Request] = [:]
    static var resources : [String : String] = [:]
    static var readInFormatter = DateFormatter()
    static var outputFormatter = DateFormatter()
    
    // Initializes firebase functionality
    public static func initFirebase(){
        FirebaseApp.configure()
    }
    
    
    public static func initDateFormatters(){
        readInFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        outputFormatter.dateFormat = "MMM dd, HH:mm"
    }
    
    public static func getResource(key: String) -> String {
        let resource = resources[key]!
        return resource
    }
    
    // Sends new data to the data source
    public static func sendData(data : Request){
        let key = ref.child("requests").childByAutoId().key!
        updateData(data: data, key: key)
    }
    
    
    // Updates an existing entry in the data source
    public static func updateData(data: Request, key: String){
        ref.child("requests").child(key).setValue(data.requestData)
    }
    
    
    public static func getCurrentRequests() -> [String : Request] {
        return requests
    }
    
    
    // Returns a Dictonary of all requests where the specified column matches the the given value
    public static func getCurrentRequestsWhere(column:String, equals value:String) -> [String : Request] {
        var results : [String : Request] = [:]
        
        for request in requests {
            if(request.value.requestData[column] as! String == value) {
                results[request.key] = request.value
            }
        }
        
        return results
    }
    
    
    // Begins observing the request s table and updates local collection with latest data
    public static func startRequestSync() {
        let resultsRef = ref.child("requests")
        
        resultsRef.observe(DataEventType.value, with: { (snapshot) in
            requests = getCollectionFromDataSnapshot(data: snapshot)
        })
    }
    
    public static func startResourceSync() {
        let resultsRef = ref.child("Resources")
        
        resultsRef.observe(DataEventType.value, with: { (snapshot) in
            resources = getResourceDataFromSnapshot(data: snapshot)
        })
    }
    
    private static func getResourceDataFromSnapshot(data snapshot:DataSnapshot) -> [String : String]{
        var results : [String : String] = [:]
        
        for result in snapshot.children.allObjects as! [DataSnapshot] {
            results[result.key] = (result.value as! String)
        }
        return results
    }
    
    
    // Creates and returns a Dictionary of Results from a given DataSnapshot object
    private static func getCollectionFromDataSnapshot(data snapshot:DataSnapshot) -> [String : Request]{
        var results : [String : Request] = [:]

        //Add all results to collection
        for result in snapshot.children.allObjects as! [DataSnapshot] {
            let request = Request()
            request.requestData = (result.value as! [String : Any])
            results[result.key] = request
        }
        
        return results
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
