//
//  Status.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/29/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Foundation

public enum Status {
    case available, inProgress, completed, empty, cancelled
}


public func getStatusString(_ status: Status) -> String {
    switch status {
    case .available:
        return "Available"
    case .inProgress:
        return "In Progress"
    case .completed:
        return "Completed"
    case .cancelled:
        return "Cancelled"
    default:
        return ""
    }
}


public func resolveStatus(fromString string: String) -> Status {
    switch string {
    case "Available":
        return .available
    case "In Progress":
        return .inProgress
    case "Completed":
        return .completed
    case "Cancelled":
        return .cancelled
    default:
        return .empty
    }
}
