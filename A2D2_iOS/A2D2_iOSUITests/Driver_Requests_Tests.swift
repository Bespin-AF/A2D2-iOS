//
//  Driver_Requests_Tests.swift
//  A2D2_iOSUITests
//
//  Created by Daniel Crean on 3/28/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import XCTest

class Driver_Requests_Tests: A2D2_iOSUITests {

    //Tests that the Driver Requests page has a table to contain the requests
    func testDriverRequests_HasAllComponents() {
        goToRideRequestsPage()
        XCTAssert(app.navigationBars["Ride Requests"].waitForExistence(timeout: 10))
        XCTAssert(app.tables.count == 1)
    }
}
