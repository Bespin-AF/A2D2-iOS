//
//  A2D2_Home_Tests.swift
//  A2D2_iOSUITests
//
//  Created by Daniel Crean on 3/28/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import XCTest

class A2D2_Home_Tests: A2D2_iOSUITests {

    // Tests the home page for all UI Components
    func testHome_HasAllComponents(){
        XCTAssert(app.images["img_A2D2Logo"].exists)
        XCTAssert(app.buttons["btn_RequestRide"].exists)
        XCTAssert(app.buttons["btn_RequestRide"].isEnabled)
        XCTAssert(app.buttons["btn_DriverLogin"].exists)
        XCTAssert(app.buttons["btn_DriverLogin"].isEnabled)
    }
}
