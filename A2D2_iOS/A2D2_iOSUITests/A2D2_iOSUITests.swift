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
    
    func goToRulesPage(){
        app.buttons["Request Ride"].tap()
    }
    
    
    func goToPickupRequestOptionsPage() {
        goToRulesPage()
        app.buttons["Agree"].tap()
        //Will need to handle Navigations Permissions here
    }
    
    
    func goToRideStatusPage(){
        goToPickupRequestOptionsPage()
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("Test Name")
        app.textFields["Phone Number"].tap()
        app.textFields["Phone Number"].typeText("3345389408")
        app.staticTexts["Gender"].tap()
        app.buttons["Request Driver"].tap()
        //Will need to handle mandatory fields and input here
        //Alert as well
    }
    
    
    func goToDriverLoginPage(){
        app.buttons["Driver Login"].tap()
    }
    
    
    func goToRideRequestsPage(){
        goToDriverLoginPage()
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("sheldon@boot.com")
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("fruitloops")
        app.accessibilityActivate()
        app.staticTexts["Welcome!"].tap()//Slightly Hacky -- Find better way to tap off
        app.buttons["Login"].tap()
    }
    
    
    func goToRideRequestsDetailPage(){
        goToRideRequestsPage()
        if(app.cells.count > 0){
            app.cells.firstMatch.tap()
        }
    }
    
    /*** End Navigation ***/
    

    // Tests the home page for all UI Components
    func testHome_HasAllComponents(){
        XCTAssert(app.images["a2d2logo"].exists)
        XCTAssert(app.buttons["Request Ride"].exists)
        XCTAssert(app.buttons["Request Ride"].isEnabled)
        XCTAssert(app.buttons["Driver Login"].exists)
        XCTAssert(app.buttons["Driver Login"].isEnabled)
    }

    
    //Test that the Request ride button navigates to A2D2Rules
    func testA2D2Rules_HasAllComponents(){
        goToRulesPage()
        XCTAssert(app.navigationBars["A2D2 Rules"].exists)
        XCTAssert(app.buttons["Agree"].exists)
        XCTAssert(app.buttons["Agree"].isEnabled)
    }


    //Test that Pickup Request Options Page shows after Location Permissions have been granted
    func testA2D2Rules_AgreeAfterPermissionGranted() {
        goToPickupRequestOptionsPage()
        XCTAssert(app.navigationBars["Pickup Request Options"].exists)
    }
    
    
    //Group Size Picker appears on Pickup Request Options Page
    func testRequest_HasAllComponents(){
        goToPickupRequestOptionsPage()
        XCTAssert(app.staticTexts["Group Size"].exists)
        XCTAssert(app.staticTexts["Group Size"].isEnabled)
        XCTAssert(app.staticTexts["Gender"].exists)
        XCTAssert(app.staticTexts["Gender"].isEnabled)
        XCTAssert(app.textFields["Name"].exists)
        XCTAssert(app.textFields["Name"].isEnabled)
        XCTAssert(app.textFields["Phone Number"].exists)
        XCTAssert(app.textFields["Phone Number"].isEnabled)
        XCTAssert(app.textViews["Comments (Optional)"].exists)
        XCTAssert(app.textViews["Comments (Optional)"].isEnabled)
    }
    
    
    //Tests that the Cancel Option keeps user on Pickup Request Options Page
    func testRequiresName() {
        goToPickupRequestOptionsPage()
        app.buttons["Request Driver"].tap()
        sleep(1)
        XCTAssert(app.alerts["Name is a required field."].exists)
    }
    
    
    //Tests that the Confirm Button navigates user to Ride Status Page
    func testRequest_ConfirmPickup() {
        goToRideStatusPage()
        app.alerts["Confirm Driver Request"].buttons["Confirm"].tap()
        sleep(1)
        XCTAssert(app.navigationBars["Ride Status"].exists)
    }
    
    
    //Tests that the Cancel Option keeps user on Pickup Request Options Page
    func testRequest_CancelPickup() {
        goToRideStatusPage()
        sleep(1)
        app.alerts["Confirm Driver Request"].buttons["Cancel"].tap()
        sleep(1)
        XCTAssert(app.navigationBars["Pickup Request Options"].exists)
    }
    

    //Tests that login page has all required fields
    func testDriverLogin_HasAllComponents() {
        goToDriverLoginPage()
        XCTAssert(app.textFields["Email"].exists)
        XCTAssert(app.textFields["Email"].isEnabled)
        XCTAssert(app.secureTextFields["Password"].exists)
        XCTAssert(app.secureTextFields["Password"].isEnabled)
        XCTAssert(app.buttons["Login"].exists)
        XCTAssert(app.buttons["Login"].isEnabled)
    }
    
    
    //Tests that invalid login keeps user at login page
    func testDriverLogin_LoginRequiresInput(){
        goToDriverLoginPage()
        app.buttons["Login"].tap()
        XCTAssert(!app.navigationBars["Ride Requests"].exists)
    }
    
    
    //Tests that having username and password progresses user to next screen
    func testDriverLogin_ValidLoginDoesNavigate(){
        goToRideRequestsPage()
        sleep(1)
        XCTAssert(app.navigationBars["Ride Requests"].exists)
    }
    
    
    //Tests that the Driver Requests page has a table to contain the requests
    func testDriverRequests_HasAllComponents(){
        goToRideRequestsPage()
        sleep(1)
        XCTAssert(app.tables.count == 1)
    }
    

    //Tests that the Driver Request Details page has all required components
    func testDriverRequestDetails_HasAllComponents(){
        goToRideRequestsDetailPage()
        if(app.cells.count > 0){
            XCTAssert(app.navigationBars["Ride Request Details"].exists)
            XCTAssert(app.staticTexts["Status:"].exists)
            XCTAssert(app.staticTexts["Phone Number:"].exists)
            XCTAssert(app.staticTexts["Group Size:"].exists)
            XCTAssert(app.staticTexts["Name:"].exists)
            XCTAssert(app.staticTexts["Rider Remarks"].exists)
            XCTAssert(app.buttons["Text Rider"].exists)
            XCTAssert(app.buttons["Text Rider"].isEnabled)
            XCTAssert(app.buttons["Take Job"].exists)
            XCTAssert(app.buttons["Take Job"].isEnabled)
        }
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
