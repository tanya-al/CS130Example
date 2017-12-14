//
//  SimplicityUITests.swift
//  SimplicityUITests
//
//  Created by Anthony Lai on 10/31/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import XCTest

class SimplicityUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        
        sleep(1)
        
        //hit the home button
        tabBarsQuery.buttons["Home"].tap()
        
        sleep(1)
        
        //hit transaction button
        tabBarsQuery.buttons["Transactions"].tap()
        
        sleep(1)
        
        //hit receipts button
        tabBarsQuery.buttons["Receipts"].tap()
        
        sleep(1)
        
        let collectionViewsQuery = app.collectionViews
        
        //click one receipt image
        collectionViewsQuery.children(matching: .cell).element(boundBy: 8).children(matching: .other).element.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        
        sleep(1)
        
        let backButton = app.buttons["Back"]
        //go back to receipts tab
        backButton.tap()
        
        sleep(1)
        
        //hit another image
        collectionViewsQuery.children(matching: .cell).element(boundBy: 19).children(matching: .other).element.tap()
        
        sleep(1)
        
        //go back to receipts tab
        backButton.tap()
        
        sleep(1)
        
        //hit setting button
        tabBarsQuery.buttons["Settings"].tap()
    }
    
}
