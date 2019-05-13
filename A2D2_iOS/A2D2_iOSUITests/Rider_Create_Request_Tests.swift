//
//  Rider_Create_Request_Tests.swift
//  A2D2_iOSUITests
//
//  Created by Daniel Crean on 3/28/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import XCTest

class Rider_Create_Request_Tests: A2D2_iOSUITests {

    //Group Size Picker appears on Pickup Request Options Page
    func testRequest_HasAllComponents() {
        goToPickupRequestOptionsPage()
        XCTAssert(doesViewExist(viewName: "vw_PickupRequestOptions"))
        XCTAssert(app.pickers["pkr_GroupSize"].exists)
        XCTAssert(app.pickers["pkr_GroupSize"].isEnabled)
        XCTAssert(app.pickers["pkr_Gender"].exists)
        XCTAssert(app.pickers["pkr_Gender"].isEnabled)
        XCTAssert(app.textFields["txtFld_Name"].exists)
        XCTAssert(app.textFields["txtFld_Name"].isEnabled)
        XCTAssert(app.textFields["txtFld_PhoneNumber"].exists)
        XCTAssert(app.textFields["txtFld_PhoneNumber"].isEnabled)
        XCTAssert(app.otherElements["txtVw_Remarks"].exists)
        XCTAssert(app.otherElements["txtVw_Remarks"].isEnabled)
    }
    
    //Tests that the Cancel Option keeps user on Pickup Request Options Page
    func testRequiresName() {
        goToPickupRequestOptionsPage()
        XCTAssert(doesViewExist(viewName: "vw_PickupRequestOptions"))
        app.staticTexts["Gender"].tap()
        app.buttons["btn_RequestDriver"].tap()
        XCTAssert(app.alerts["Name is a required field."].waitForExistence(timeout: 10))
    }
    
    
    //Tests that the Confirm Button navigates user to Ride Status Page
    func testRequest_ConfirmPickup() {
        goToRideStatusPage()
        XCTAssert(app.images["a2d2logo"].waitForExistence(timeout: 10))
    }
    
    
    //Tests that the Cancel Option keeps user on Pickup Request Options Page
    func testRequest_CancelPickup() {
        goToPickupRequestOptionsPage()
        app.textFields["txtFld_Name"].tap()
        app.textFields["txtFld_Name"].typeText("Automated Test Name")
        app.textFields["txtFld_PhoneNumber"].tap()
        app.textFields["txtFld_PhoneNumber"].typeText("0000000000")
        app.staticTexts["Gender"].tap()
        app.buttons["btn_RequestDriver"].tap()
        app.alerts["Confirm Driver Request"].buttons["Cancel"].tap()
        XCTAssert(app.navigationBars["Pickup Request Options"].waitForExistence(timeout: 10))
    }
}
