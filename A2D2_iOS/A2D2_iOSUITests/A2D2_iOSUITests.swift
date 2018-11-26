//
//  A2D2_iOSUITests.swift
//  A2D2_iOSUITests
//
//  Created by Justin Godsey on 11/13/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import XCTest
import CoreLocation

class A2D2_iOSUITests: XCTestCase {
    let RequestRideBtn = "Request Ride"
    let RulesAgreeBtn = "Agree"
    var app: XCUIApplication!
    var didAlertShow = false
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.

    }

    
    override func tearDown() {
        app.terminate()
    }

    
    func testRequestRideView_IsShowing(){
        //Tests that Request ride view exists
        XCTAssert(app.images["a2d2logo"].exists)
        XCTAssert(app.buttons[RequestRideBtn].exists)
        XCTAssert(app.buttons[RequestRideBtn].isEnabled)
    }

    
    func testRequestRideButton_DoesNavigate(){
        //Tests that the Request ride button navigates away
        app.buttons[RequestRideBtn].tap()
        XCTAssert(!app.images["a2d2logo"].exists)
        XCTAssert(!app.buttons[RequestRideBtn].exists)
    }
    
    
    func testA2D2RulesView_DoesShow(){
        //Test that the Request ride button navigates to A2D2Rules
        app.buttons[RequestRideBtn].tap()
        XCTAssert(app.staticTexts["A2D2 Rules"].exists)
    }

    
    func testAgreeButton_DoesShow(){
        //Test that the Agree button exists
        app.buttons[RequestRideBtn].tap()
        XCTAssert(app.buttons[RulesAgreeBtn].exists)
    }
    
    
    func testAllowButton_DoesNavigate(){
        //When Agree is selected user is navigated to the request ride page
        addUIInterruptionMonitor(withDescription: "Location Dialog") { (alert) ->Bool in
            let agreeButton = alert.buttons["Allow"]
            if agreeButton.exists{
                agreeButton.tap()
            }
            return true
        }
        
        app.buttons[RequestRideBtn].tap()
        app.buttons[RulesAgreeBtn].tap()
        app.tap()
        sleep(1)
        XCTAssert(app.staticTexts["Pickup Request Options"].exists)
    }
    
    
    func testDenyButton_DoesAlert(){
        //When Agree is selected user is navigated to the request ride page
        addUIInterruptionMonitor(withDescription: "Location Dialog") { (alert) ->Bool in
            let denyButton = alert.buttons["Deny"]
            if denyButton.exists{
                denyButton.tap()
            }
            return false
        }
        
        app.buttons[RequestRideBtn].tap()
        app.buttons[RulesAgreeBtn].tap()
        app.tap()
        sleep(1)
        let title = app.navigationBars["Pickup Request Options"].otherElements["Pickup Request Options"]
        XCTAssert(title.exists)
    }
}
