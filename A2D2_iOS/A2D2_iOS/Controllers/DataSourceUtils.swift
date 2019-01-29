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

class DataSourceUtils{
    static var ref = Database.database().reference()
    static var requests : [String : Request] = [:]
    
    public static func initFirebase(){
        FirebaseApp.configure()
    }
    
    
    public static func sendData(data : Request){
        let key = ref.child("requests").childByAutoId().key!
        updateData(data: data, key: key)
    }
    
    
    public static func updateData(data : Request, key: String){
        ref.child("requests").child(key).setValue(data)
    }
    
    
    public static func getCurrentRequests() -> [String : Request] {
        return requests
    }
    
    
    public static func getCurrentRequestsWhere(column key:String, equals value:String) -> [String : Request] {
        var results : [String : Request] = [:]
        
        for request in requests {
            if(request.value.requestData[key] as! String == value) {
                results[request.key] = request.value
            }
        }
        
        return results
    }
    
    
    public static func startRequestSync() {
        let resultsRef = ref.child("requests")
        
        resultsRef.observe(DataEventType.value, with: { (snapshot) in
            requests = getCollectionFromDataSnapshot(data: snapshot)
        })
    }
    
    
    //Creates an Dictionary of Results from a DataSnapshot object
    private static func getCollectionFromDataSnapshot(data snapshot:DataSnapshot) -> [String : Request]{
        var results : [String : Request] = [:]

        //Add all results to collection
        for result in snapshot.children.allObjects as! [DataSnapshot] {
            results[result.key] = (result.value as! [String : Any])
        }
        
        return results
    }
}
