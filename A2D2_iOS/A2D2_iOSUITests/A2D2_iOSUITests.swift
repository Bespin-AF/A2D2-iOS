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
    let requestRideBtn = "Request Ride"
    let rulesAgreeBtn = "Agree"
    let requestDriverBtn = "Request Driver"
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
        XCTAssert(app.buttons[requestRideBtn].exists)
        XCTAssert(app.buttons[requestRideBtn].isEnabled)
    }

    
    func testRequestRideButton_DoesNavigate(){
        //Tests that the Request ride button navigates away
        app.buttons[requestRideBtn].tap()
        sleep(1)
        XCTAssert(!app.images["a2d2logo"].exists)
        XCTAssert(!app.buttons[requestRideBtn].exists)
    }
    
    
    func testA2D2RulesView_DoesShow(){
        //Test that the Request ride button navigates to A2D2Rules
        app.buttons[requestRideBtn].tap()
        XCTAssert(app.navigationBars["A2D2 Rules"].exists)
    }

    
    func testAgreeButton_DoesShow(){
        //Test that the Agree button exists
        app.buttons[requestRideBtn].tap()
        XCTAssert(app.buttons[rulesAgreeBtn].exists)
    }
    
    
//    func testAllowButton_DoesNavigate(){
//        //When Agree is selected user is navigated to the request ride page
//        addUIInterruptionMonitor(withDescription: "Location Permissions") { (alert) ->Bool in
//            let agreeButton = alert.buttons["Allow"]
//            if agreeButton.exists{
//                agreeButton.tap()
//                return true
//            }
//            XCTFail("Unexpected Alert")
//            return false
//        }
//
//        app.buttons[requestRideBtn].tap()
//        app.buttons[rulesAgreeBtn].tap()
//        app.tap()
//        sleep(1)
//        let title = app.navigationBars["Pickup Request Options"].otherElements["Pickup Request Options"]
//        XCTAssert(title.exists)
//    }
//
//
//    func testDenyButton_DoesAlert(){
//        //When Deny is selected user is alerted to our disgust of them
//        addUIInterruptionMonitor(withDescription: "Location Dialog") { (alert) ->Bool in
//            print("BEARS!!!!")
//            print(alert)
//            print(alert.buttons.count)
//            let denyButton = alert.buttons["Don't Allow"]
//            if(denyButton.exists){
//                denyButton.tap()
//                return true
//            }
//            XCTFail("Unexpected Alert")
//            return false
//        }
//
//        app.buttons[requestRideBtn].tap()
//        app.buttons[rulesAgreeBtn].tap()
//        app.tap()
//        sleep(1)
//        XCTAssert(app.alerts["Location Not Enabled"].exists)
//    }
    
//    func testAgreeAfterDenied_HasOK(){
//        app.buttons[requestRideBtn].tap()
//        app.buttons[rulesAgreeBtn].tap()
//        XCTAssert(app.alerts["Location Not Enabled"].buttons["Okay"].exists)
//    }
    
    func testAgreeAfterAccepted_DoesNavigate() {
        app.buttons[requestRideBtn].tap()
        app.buttons[rulesAgreeBtn].tap()
        XCTAssert(app.navigationBars["Pickup Request Options"].exists)
    }
    
    func testRequest_HasGroupSize(){
        app.buttons[requestRideBtn].tap()
        app.buttons[rulesAgreeBtn].tap()
        XCTAssert(app.staticTexts["Group Size"].exists)
    }
    
    func testRequest_HasGender(){
        app.buttons[requestRideBtn].tap()
        app.buttons[rulesAgreeBtn].tap()
        XCTAssert(app.staticTexts["Gender"].exists)
    }
    
    func testRequest_DoesRemarksExists(){
        app.buttons[requestRideBtn].tap()
        app.buttons[rulesAgreeBtn].tap()
        XCTAssert(app.textViews.count > 0)
    }
    
    func testRequest_DoesPlaceHolderExist(){
        app.buttons[requestRideBtn].tap()
        app.buttons[rulesAgreeBtn].tap()
        XCTAssert(app.textViews["Comments (Optional)"].exists)
    }
    func testConfirmPickup_DoesNavigate() {
        app.buttons[requestRideBtn].tap()
        app.buttons[rulesAgreeBtn].tap()
        app.buttons[requestDriverBtn].tap()
        app.alerts["Confirm Driver Request"].buttons["Confirm"].tap()
        XCTAssert(app.navigationBars["Ride Status"].exists)
    }
    func testRequestRideButton_DoesShow(){
        //Test that the Agree button exists
        app.buttons[requestRideBtn].tap()
        XCTAssert(app.buttons[requestRideBtn].exists)
    }
}
