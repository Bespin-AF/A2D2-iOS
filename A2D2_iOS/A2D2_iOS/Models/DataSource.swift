//
//  DataSource.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 4/11/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Firebase

public enum DataSourceType {
    case Requests, Resources, TestRequests, Locations
}


func getDataSourceTypeRef(_ ref: DatabaseReference, dataTable type:DataSourceType) -> DatabaseReference {
    switch type {
    case .Requests:
        return ref.child("requests")
    case .Resources:
        return ref.child("base_info")
    case .TestRequests:
        return ref.child("test_requests")
    case .Locations:
        return Database.database().reference().child("locations")
    }
}


class DataSource {
    private var ref = Database.database().reference().child("bases").child(DataSourceUtils.a2d2Base)
    var delegate : DataSourceDelegate?{
        didSet{
            startSync()
        }
    }
    
    init(_ type : DataSourceType) {
        ref = getDataSourceTypeRef(ref, dataTable: type)
    }
    
    
    deinit {
        ref.removeAllObservers()
    }
    
    
    public func sendData(data : Any) -> String{
        let key = ref.childByAutoId().key!
        set(key: key, value: data)
        return key
    }
    
    
    public func update(key:String, data: Any){
        set(key: key, value: data)
    }
    
    
    public func remove(key: String){
        ref.child(key).removeValue()
    }
    
    
    private func set(key : String, value : Any){
        ref.child(key).setValue(value)
    }
    
    
    private func startSync() {
        ref.observe(DataEventType.value, with: { (snapshot) in
            self.dataValues(snapshot)
        })
        ref.observe(DataEventType.childChanged, with: { (snapshot) in
            self.didDataChange(snapshot)
        })
        ref.observe(DataEventType.childAdded, with: { (snapshot) in
            self.didAddData(snapshot)
        })
        ref.observe(DataEventType.childRemoved, with: { (snapshot) in
            self.didRemoveData(snapshot)
        })
    }
    
    
    private func didDataChange(_ snapshot : DataSnapshot) {
        if let delegate = self.delegate {
            let data = convertSnapshotToDictionary(snapshot)
            delegate.dataSource(self, didDataChange: data)
        }
    }
    
    
    private func didAddData(_ snapshot : DataSnapshot) {
        if let delegate = self.delegate {
            let data = convertSnapshotToDictionary(snapshot)
            delegate.dataSource(self, didAddData: data)
        }
    }
    
    
    private func didRemoveData(_ snapshot : DataSnapshot) {
        if let delegate = self.delegate {
            let data = convertSnapshotToDictionary(snapshot)
            delegate.dataSource(self, didRemoveData: data)
        }
    }
    
    
    private func dataValues(_ snapshot : DataSnapshot) {
        if let delegate = self.delegate {
            let data = convertSnapshotToDictionary(snapshot)
            delegate.dataSource(self, dataValues: data)
        }
    }
    
    
    private func convertSnapshotToDictionary(_ snapshot : DataSnapshot) -> [String:Any] {
        var results : [String : Any] = [:]
        
        for result in snapshot.children.allObjects as! [DataSnapshot] {
            results[result.key] = result.value // TODO Establish data standards
        }
        
        return results
    }
}
