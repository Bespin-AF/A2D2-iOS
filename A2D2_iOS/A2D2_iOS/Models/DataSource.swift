//
//  DataSource.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 4/11/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Firebase

public enum DataSourceType {
    case Requests, Resources, TestRequests
}


func getDataSourceTypeString(dataTable type:DataSourceType) -> String {
    switch type {
    case .Requests:
        return "requests"
    case .Resources:
        return "Resources"
    case .TestRequests:
        return "test_requests"
    }
}


class DataSource {
    private var ref = Database.database().reference()
    weak var delagate : DataSourceDelagate?
    
    init(_ type : DataSourceType) {
        let table = getDataSourceTypeString(dataTable: type)
        ref = Database.database().reference().child(table)
        startSync()
    }
    
    
    deinit {
        ref.removeAllObservers()
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
        if let delagate = self.delagate {
            let data = convertSnapshotToDictionary(snapshot)
            delagate.dataChanged(self, data: data)
        }
    }
    
    
    private func didAddData(_ snapshot : DataSnapshot) {
        if let delagate = self.delagate {
            let data = convertSnapshotToDictionary(snapshot)
            delagate.dataAdded(self, data: data)
        }
    }
    
    
    private func didRemoveData(_ snapshot : DataSnapshot) {
        if let delagate = self.delagate {
            let data = convertSnapshotToDictionary(snapshot)
            delagate.dataRemoved(self, data: data)
        }
    }
    
    
    private func dataValues(_ snapshot : DataSnapshot) {
        if let delagate = self.delagate {
            let data = convertSnapshotToDictionary(snapshot)
            delagate.dataValue(self, data: data)
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
