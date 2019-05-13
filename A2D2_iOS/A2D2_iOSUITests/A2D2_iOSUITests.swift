//
//  A2D2_iOSUITests.swift
//  A2D2_iOSUITests
//
//  Created by Justin Godsey on 11/13/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import XCTest

class A2D2_iOSUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    
    override func tearDown() {
        app.terminate()
    }
    
    
    /***** Navigation Functions *****/
    
    //this function will also give the view enough time to load
    func doesViewExist(viewName: String) -> Bool {
        let requestView = app.otherElements[viewName]
        let viewExists = requestView.waitForExistence(timeout: 10)
        if viewExists {
            return true
        } else {return false}
    }
    
    
    func goToRulesPage() {
        app.buttons["btn_RequestRide"].tap()
    }
    
    
    func goToPickupRequestOptionsPage() {
        goToRulesPage()
        addUIInterruptionMonitor(withDescription: "Location permission", handler: { alert in
            alert.buttons["Allow"].tap()
            return true
        })
        sleep(2)//Give time for loading
        app.buttons["btn_Agree"].tap()
        app.tap()
        XCTAssert(app.navigationBars["Pickup Request Options"].waitForExistence(timeout: 10))
    }
    
    
    func goToRideStatusPage() {
        goToPickupRequestOptionsPage()
        app.textFields["txtFld_Name"].tap()
        app.textFields["txtFld_Name"].typeText("Automated Test Name")
        app.textFields["txtFld_PhoneNumber"].tap()
        app.textFields["txtFld_PhoneNumber"].typeText("0000000000")
        app.staticTexts["Gender"].tap()
        app.buttons["btn_RequestDriver"].tap()
        app.alerts["Confirm Driver Request"].buttons["Confirm"].tap()
    }
    
    
    func goToDriverLoginPage() {
        app.buttons["btn_DriverLogin"].tap()
    }
    
    
    func goToRideRequestsPage() {
        goToDriverLoginPage()
        app.textFields["txtFld_Email"].tap()
        app.textFields["txtFld_Email"].typeText("sheldon@boot.com")
        app.secureTextFields["txtFld_Password"].tap()
        app.secureTextFields["txtFld_Password"].typeText("fruitloops")
        app.accessibilityActivate()
        app.staticTexts["Welcome!"].tap()//Slightly Hacky -- Find better way to tap off
        app.otherElements["vw_DriverLogin"].tap()
        app.buttons["btn_Login"].tap()
    }
    
    
    func goToRideRequestsDetailPage() {
        goToRideRequestsPage()
        XCTAssert(app.cells["cell_RequestStatus"].waitForExistence(timeout: 10))
        app.cells.element(boundBy: 0).tap()
    }
    
    /*** End Navigation ***/
    
    /***** System Alert Handling / Permissions Test *****/
    
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
}
