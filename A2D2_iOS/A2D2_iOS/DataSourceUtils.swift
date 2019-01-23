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
    static var requests : [[String : Any]] = [[:]]
    
    public static func sendData(data : [String : Any]){
        let key = ref.child("requests").childByAutoId().key!
        ref.child("requests").child(key).setValue(data)
    }
    
    
    public static func getCurrentRequests() -> [[String : Any]] {
        return requests
    }
    
    
    public static func getCurrentRequestsWhere(column key:String, equals value:String) -> [[String : Any]] {
        var results : [[String:Any]] = []
        
        for request in requests {
            if(request[key] as! String == value) {
                results.append(request)
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
    
    
    //Creates an Array of Dictionaries from a DataSnapshot object
    private static func getCollectionFromDataSnapshot(data snapshot:DataSnapshot) -> [[String : Any]]{
        var results : [[String : Any]] = []

        //Add all results to collection
        for result in snapshot.children.allObjects as! [DataSnapshot] {
            results.append(result.value as! [String : Any])
        }
        
        return results
    }
}
