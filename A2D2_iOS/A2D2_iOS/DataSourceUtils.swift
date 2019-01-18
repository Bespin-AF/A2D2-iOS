//
//  DataSourceUtils.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/18/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Firebase

class DataSourceUtils{
    static var ref : DatabaseReference!
    
    
    public static func sendData(data : [String:Any]){
        ref = Database.database().reference()
        let key = ref.child("requests").childByAutoId().key!
        ref.child("requests").child(key).setValue(data)
    }
}
