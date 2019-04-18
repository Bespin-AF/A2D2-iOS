//
//  DataSourceDelagate.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 4/11/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

protocol DataSourceDelegate {
    func dataSource(_ dataSource : DataSource, didDataChange : [String:Any])
    func dataSource(_ dataSource : DataSource, didAddData : [String:Any])
    func dataSource(_ dataSource : DataSource, didRemoveData : [String:Any])
    func dataSource(_ dataSource : DataSource, dataValues : [String:Any])
}


extension DataSourceDelegate {
    func dataSource(_ dataSource : DataSource, didDataChange : [String:Any]){}
    func dataSource(_ dataSource : DataSource, didAddData : [String:Any]){}
    func dataSource(_ dataSource : DataSource, didRemoveData : [String:Any]){}
    func dataSource(_ dataSource : DataSource, dataValues : [String:Any]){}
}
