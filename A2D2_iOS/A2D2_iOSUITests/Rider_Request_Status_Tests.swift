//
//  Rider_Request_Status_Tests.swift
//  A2D2_iOSUITests
//
//  Created by Daniel Crean on 4/19/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import XCTest

class Rider_Request_Status_Tests: A2D2_iOSUITests {
    func testStatus_HasAllComponents(){
        goToRideStatusPage()
        XCTAssert(app.images["a2d2logo"].exists)
    }
    
    
    func testStatus_CancelRequestButton(){
        goToRideStatusPage()
        app.buttons["Cancel Ride"].tap()
        app.alerts["Confirm Cancellation"].buttons["Confirm"].tap()
        app.alerts["Cancelled"].buttons["Okay"].tap()
    }
}
