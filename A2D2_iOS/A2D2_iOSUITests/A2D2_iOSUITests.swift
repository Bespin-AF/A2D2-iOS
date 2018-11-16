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
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }
    
    func testRequestRideView_IsShowing(){
        //Tests that Request ride view exists
        XCTAssert(app.images["a2d2logo"].exists)
        XCTAssert(app.buttons["Request ride"].exists)
    }
    
    func testRequestRideButton_IsEnabled(){
        XCTAssert(app.buttons["Request ride"].isEnabled)
    }
    
    func testRequestRideButton_DoesNavigate(){
        app.buttons["Request ride"].tap()
        XCTAssert(!app.images["a2d2logo"].exists)
        XCTAssert(!app.buttons["Request ride"].exists)
    }
}
