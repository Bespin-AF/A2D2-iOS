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
    var app: XCUIApplication!
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this."Request Driver"
    }

    
    override func tearDown() {
        app.terminate()
    }
    
    
    /***** Navigation Functions *****/
    
    //this function will also give the view enough time to load
    func doesViewExist(viewName: String) -> Bool {
        let requestView = app.otherElements[viewName]
        let viewExists = requestView.waitForExistence(timeout: 10)
        if viewExists{
            return true
        }
        else {return false}
    }
    
    
    func goToRulesPage(){
        app.buttons["btn_RequestRide"].tap()
    }
    
    
    func goToPickupRequestOptionsPage(){
        goToRulesPage()
        app.buttons["btn_Agree"].tap()
        addUIInterruptionMonitor(withDescription: "Location permission", handler: { alert in
            alert.buttons["Allow"].tap()
            return true
        })
        app.tap()
        //Will need to handle Navigations Permissions here
    }
    
    
    func goToRideStatusPage(){
        goToPickupRequestOptionsPage()
        XCTAssert(doesViewExist(viewName: "vw_PickupRequestOptions"))
        app.textFields["txtFld_Name"].tap()
        app.textFields["txtFld_Name"].typeText("Test Name")
        app.textFields["txtFld_PhoneNumber"].tap()
        app.textFields["txtFld_PhoneNumber"].typeText("3345389408")
//        app.staticTexts["Gender"].tap()
        app.staticTexts["Gender"].tap()
        app.buttons["btn_RequestDriver"].tap()
        //Will need to handle mandatory fields and input here
        //Alert as well
    }
    
    
    func goToDriverLoginPage(){
        app.buttons["btn_DriverLogin"].tap()
    }
    
    
    func goToRideRequestsPage(){
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
    
    
    func goToRideRequestsDetailPage(){
        goToRideRequestsPage()
        XCTAssert(app.cells["cell_RequestStatus"].waitForExistence(timeout: 10))
        app.cells.element(boundBy: 0).tap()
    }
    
    /*** End Navigation ***/
    

    // Tests the home page for all UI Components
    func testHome_HasAllComponents(){
        XCTAssert(app.images["img_A2D2Logo"].exists)
        XCTAssert(app.buttons["btn_RequestRide"].exists)
        XCTAssert(app.buttons["btn_RequestRide"].isEnabled)
        XCTAssert(app.buttons["btn_DriverLogin"].exists)
        XCTAssert(app.buttons["btn_DriverLogin"].isEnabled)
    }

    
    //Test that the Request ride button navigates to A2D2Rules
    func testA2D2Rules_HasAllComponents(){
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
    
    
    //Group Size Picker appears on Pickup Request Options Page
    func testRequest_HasAllComponents(){
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
        XCTAssert(app.textViews["txtVw_Remarks"].exists)
        XCTAssert(app.textViews["txtVw_Remarks"].isEnabled)
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
        app.alerts["Confirm Driver Request"].buttons["Confirm"].tap()
        XCTAssert(app.navigationBars["Ride Status"].waitForExistence(timeout: 10))
    }
    
    
    //Tests that the Cancel Option keeps user on Pickup Request Options Page
    func testRequest_CancelPickup() {
        goToRideStatusPage()
        app.alerts["Confirm Driver Request"].buttons["Cancel"].tap()
        XCTAssert(app.navigationBars["Pickup Request Options"].waitForExistence(timeout: 10))
    }
    

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
    func testDriverLogin_LoginRequiresInput(){
        goToDriverLoginPage()
        XCTAssert(doesViewExist(viewName: "vw_DriverLogin"))
        app.buttons["btn_Login"].tap()
        XCTAssert(!app.navigationBars["Ride Requests"].exists)
    }
    
    
    //Tests that having username and password progresses user to next screen
    func testDriverLogin_ValidLoginDoesNavigate(){
        goToRideRequestsPage()
        XCTAssert(app.navigationBars["Ride Requests"].waitForExistence(timeout: 10))
        XCTAssert(app.cells["cell_RequestStatus"].waitForExistence(timeout: 10))
    }
    
    
    //Tests that the Driver Requests page has a table to contain the requests
    func testDriverRequests_HasAllComponents(){
        goToRideRequestsPage()
        XCTAssert(app.navigationBars["Ride Requests"].waitForExistence(timeout: 10))
        XCTAssert(app.tables.count == 1)
    }
    

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
