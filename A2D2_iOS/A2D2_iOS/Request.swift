//
//  Request.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 12/11/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import Foundation

class Request {
    var name : String
    var gender : String
    var comments : String
    var groupSize : Int
    var phoneNumber : String
    var latitude : Double
    var longitude : Double
    
    init() {
        name = ""
        gender = ""
        comments = ""
        groupSize = 0
        phoneNumber = ""
        latitude = 0
        longitude = 0
    }
}
