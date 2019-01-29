//
//  Status.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/29/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import Foundation

public enum Status {
    case Available, InProgress, Completed, Empty
}


public func getStatusString(_ status : Status) -> String {
    switch status {
    case .Available:
        return "Available"
    case .InProgress:
        return "In Progress"
    case .Completed:
        return "Completed"
    default:
        return ""
    }
}
