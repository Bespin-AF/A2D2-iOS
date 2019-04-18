//
//  DataSourceDelagate.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 4/11/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

protocol DataSourceDelagate : AnyObject {
    
    func dataChanged(_ dataSource : DataSource, data : [String:Any])
    func dataAdded(_ dataSource : DataSource, data : [String:Any])
    func dataRemoved(_ dataSource : DataSource, data : [String:Any])
    func dataValue(_ dataSource : DataSource, data : [String:Any])
}


extension DataSourceDelagate {
    func dataChanged(_ dataSource : DataSource, data : [String:Any]){}
    func dataAdded(_ dataSource : DataSource, data : [String:Any]){}
    func dataRemoved(_ dataSource : DataSource, data : [String:Any]){}
    func dataValue(_ dataSource : DataSource, data : [String:Any]){}
}
