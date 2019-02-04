//
//  SystemUtils.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/29/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Foundation
import UIKit

class SystemUtils {
    
    public static var currentUser : String? 
    
    public static func text(number : String, message : String = ""){
        //Percent encoding is required for use in the URL
        let text = message.addingPercentEncoding(withAllowedCharacters:.alphanumerics)!
        let url = URL(string: "sms://+\(number)/&body=\(text)")!
        UIApplication.shared.open(url)
    }
    
    
    public static func call(number : String){
        let url = URL(string: "tel://\(number)")!
        UIApplication.shared.open(url)
    }
    
    
    public static func map(lat : Double, lon : Double){
        let url = URL(string: "http://maps.apple.com/?sll=\(lat),\(lon)&t=s")!
        UIApplication.shared.open(url)
    }
}
