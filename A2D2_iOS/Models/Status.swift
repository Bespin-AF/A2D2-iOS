//
//  Status.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/29/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Foundation

public enum Status {
    case Available, InProgress, Completed, Empty, Cancelled
}


public func getStatusString(_ status : Status) -> String {
    switch status {
    case .Available:
        return "Available"
    case .InProgress:
        return "In Progress"
    case .Completed:
        return "Completed"
    case .Cancelled:
        return "Cancelled"
    default:
        return ""
    }
}


public func resolveStatus(fromString string : String) -> Status {
    switch string {
    case "Available":
        return .Available
    case "In Progress":
        return .InProgress
    case "Completed":
        return .Completed
    case "Cancelled":
        return .Cancelled
    default:
        return .Empty
    }
}
