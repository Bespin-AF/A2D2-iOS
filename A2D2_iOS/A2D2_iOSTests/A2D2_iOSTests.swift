//
//  A2D2_iOSTests.swift
//  A2D2_iOSTests
//
//  Created by Justin Godsey on 11/13/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import XCTest
@testable import A2D2_iOS

class A2D2_iOSTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testRequestButton_IsEnabled() {
        //This is to test if the request ride button is enabled and ready to go
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateInitialViewController() as! ViewController
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.requestRideButton.isEnabled)
    }
//    func testBtnRequestRide() {
//        //This is to test if the request ride button takes you to the next ViewController
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let sut = storyboard.instantiateInitialViewController() as! ViewController
//        sut.loadViewIfNeeded()
//        sut.requestRideButton(for: .touchUpInside)
//    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
