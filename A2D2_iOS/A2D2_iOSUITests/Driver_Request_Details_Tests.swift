//
//  Driver_Request_Details_Tests.swift
//  A2D2_iOSUITests
//
//  Created by Daniel Crean on 3/28/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import XCTest

class Driver_Request_Details_Tests: A2D2_iOSUITests {

    //Tests that the Driver Request Details page has all required components
    func testDriverRequestDetails_HasAllComponents(){
        goToRideRequestsDetailPage()
        XCTAssert(doesViewExist(viewName: "vw_RequestDetails"))
        XCTAssert(app.staticTexts["lbl_Status"].exists)
        XCTAssert(app.staticTexts["lbl_PhoneNumber"].exists)
        XCTAssert(app.staticTexts["lbl_GroupSize"].exists)
        XCTAssert(app.staticTexts["lbl_Name"].exists)
        XCTAssert(app.staticTexts["lbl_Remarks"].exists)
        XCTAssert(app.buttons["btn_TextRider"].exists)
        XCTAssert(app.buttons["btn_TextRider"].isEnabled)
        XCTAssert(app.buttons["btn_TakeJob"].exists)
        XCTAssert(app.buttons["btn_TakeJob"].isEnabled)
    }

}
// Let the record show that I am upset by the use of IDs in a UI test rather than visible text when available - Crean
