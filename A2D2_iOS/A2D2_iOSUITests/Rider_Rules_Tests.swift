//
//  Rider_Rules_Tests.swift
//  A2D2_iOSUITests
//
//  Created by Daniel Crean on 3/28/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import XCTest

class Rider_Rules_Tests: A2D2_iOSUITests {
    
    //Test that the Request ride button navigates to A2D2Rules
    func testA2D2Rules_HasAllComponents() {
        goToRulesPage()
        XCTAssert(doesViewExist(viewName: "vw_A2D2Rules"))
        XCTAssert(app.buttons["btn_Agree"].exists)
        XCTAssert(app.buttons["btn_Agree"].isEnabled)
    }
    
    
    //Test that Pickup Request Options Page shows after Location Permissions have been granted
    func testA2D2Rules_AgreeAfterPermissionGranted() {
        goToPickupRequestOptionsPage()
        XCTAssert(doesViewExist(viewName: "vw_PickupRequestOptions"))
    }
}
