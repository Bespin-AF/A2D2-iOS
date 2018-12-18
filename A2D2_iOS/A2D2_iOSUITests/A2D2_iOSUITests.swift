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
        app.buttons["Request Driver"].tap()
        //Will need to handle mandatory fields and input here
        //Alert as well
    }
    
    /*** End Navigation ***/

    
    //Tests that Request ride view exists
    func testRequestRideView_IsShowing(){
        XCTAssert(app.images["a2d2logo"].exists)
        XCTAssert(app.buttons["Request Ride"].exists)
        XCTAssert(app.buttons["Request Ride"].isEnabled)
    }

    
    //Test that the Request ride button navigates to A2D2Rules
    func testA2D2RulesView_DoesShow(){
        goToRulesPage()
        XCTAssert(app.navigationBars["A2D2 Rules"].exists)
    }

    
    //Test that the Agree button exists
    func testAgreeButton_DoesShow(){
        goToRulesPage()
        XCTAssert(app.buttons["Agree"].exists)
    }

    
    //Test that Pickup Request Options Page shows after Location Permissions have been granted
    func testAgreeAfterAccepted_DoesNavigate() {
        goToPickupRequestOptionsPage()
        XCTAssert(app.navigationBars["Pickup Request Options"].exists)
    }
    
    
    //Group Size Picker appears on Pickup Request Options Page
    func testRequest_HasGroupSize(){
        goToPickupRequestOptionsPage()
        XCTAssert(app.staticTexts["Group Size"].exists)
    }
    
    
    //Name Field appears on Pickup Request Options Page
    func testRequest_HasName(){
        goToPickupRequestOptionsPage()
        XCTAssert(app.textFields["Name"].exists)
    }
    
    
    //Phone Number Field appears on Pickup Request Options Page
    func testRequest_HasPhoneNumber(){
        goToPickupRequestOptionsPage()
        XCTAssert(app.textFields["Phone Number"].exists)
    }
    
    
    //Gender Picker appears on Pickup Request Options Page
    func testRequest_HasGender(){
        goToPickupRequestOptionsPage()
        XCTAssert(app.staticTexts["Gender"].exists)
    }
    
    
    //Remarks Field appears on Pickup Request Options Page
    func testRequest_DoesRemarksExists(){
        goToPickupRequestOptionsPage()
        XCTAssert(app.textViews.count > 0)
    }
    
    
    //Remarks Field has placeholder text
    func testRequest_DoesPlaceHolderExist(){
        goToPickupRequestOptionsPage()
        XCTAssert(app.textViews["Comments (Optional)"].exists)
    }
    
    
    //Tests that the Confirm Button navigates user to Ride Status Page
    func testConfirmPickup_DoesNavigate() {
        goToRideStatusPage()
        app.alerts["Confirm Driver Request"].buttons["Confirm"].tap()
        XCTAssert(app.navigationBars["Ride Status"].exists)
    }
    
    
    //Tests that the Cancel Option keeps user on Pickup Request Options Page
    func testCancelsPickup() {
        goToRideStatusPage()
        sleep(1)
        app.alerts["Confirm Driver Request"].buttons["Cancel"].tap()
        sleep(1)
        XCTAssert(app.navigationBars["Pickup Request Options"].exists)
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
