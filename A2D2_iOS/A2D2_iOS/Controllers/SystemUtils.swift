//
//  SystemUtils.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/29/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import SystemConfiguration
import Foundation
import UIKit

class SystemUtils {
    
    public static func text(number : String, message : String = ""){
        //Percent encoding is required for use in the URL
        let text = message.addingPercentEncoding(withAllowedCharacters:.alphanumerics)!
        let url = URL(string: "sms://\(number)/&body=\(text)")!
        UIApplication.shared.open(url)
    }
    
    
    public static func call(number : String){
        let url = URL(string: "tel://\(number)")!
        UIApplication.shared.open(url)
    }
    
    
    public static func map(lat : Double, lon : Double){
        let url = URL(string: "http://maps.apple.com/?daddr=\(lat),\(lon)&dirflg=d")!
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
        let regex = try! NSRegularExpression(pattern: "[\\D]")
        let range = NSRange(location: 0, length: number.count)
        number = regex.stringByReplacingMatches(in: number, range: range, withTemplate: "")
    }
    
    public static func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version) (\(build))"
    }
    
   
    // Copied from https://mobikul.com/check-internet-availability-swift/
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
    static func alertNoConnection(_ view : UIViewController) {
        let alert = UIAlertController(title: "No Connection!", message: "Can't connect to the internet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        view.present(alert, animated: true)
    }
}
