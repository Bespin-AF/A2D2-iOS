//
//  Driver_Login_Tests.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 3/28/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import XCTest

class Driver_Login_Tests: A2D2_iOSUITests {
    
    //Tests that login page has all required fields
    func testDriverLogin_HasAllComponents() {
        goToDriverLoginPage()
        XCTAssert(doesViewExist(viewName: "vw_DriverLogin"))
        XCTAssert(app.textFields["txtFld_Email"].exists)
        XCTAssert(app.textFields["txtFld_Email"].isEnabled)
        XCTAssert(app.secureTextFields["txtFld_Password"].exists)
        XCTAssert(app.secureTextFields["txtFld_Password"].isEnabled)
        XCTAssert(app.buttons["btn_Login"].exists)
        XCTAssert(app.buttons["btn_Login"].isEnabled)
    }
    
    
    //Tests that invalid login keeps user at login page
    func testDriverLogin_LoginRequiresInput() {
        goToDriverLoginPage()
        XCTAssert(doesViewExist(viewName: "vw_DriverLogin"))
        app.buttons["btn_Login"].tap()
        XCTAssert(!app.navigationBars["Ride Requests"].exists)
    }
    
    
    //Tests that having username and password progresses user to next screen
    func testDriverLogin_ValidLoginDoesNavigate() {
        goToRideRequestsPage()
        XCTAssert(app.navigationBars["Ride Requests"].waitForExistence(timeout: 10))
        XCTAssert(app.cells["cell_RequestStatus"].waitForExistence(timeout: 10))
    }

}
