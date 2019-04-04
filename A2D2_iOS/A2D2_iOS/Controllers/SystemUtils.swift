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
    
    
    public static func format(phoneNumber: String) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        
        var number = phoneNumber
        removeNonNumbers(&number)
        
        //Number over 10 digits
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        //Number under 7 digits
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            //7-10 digits
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    
    public static func removeNonNumbers(_ number: inout String){
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)A-z.*#,/+=]", options: .caseInsensitive) else { return }
        let range = NSString(string: number).range(of: number)
        number = regex.stringByReplacingMatches(in: number, options: .init(rawValue: 0), range: range, withTemplate: "")
    }
}
