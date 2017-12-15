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
        
        tabBarsQuery.buttons["Add"].tap()
        sleep(2);
        app.buttons["Take Photo"].tap()
        sleep(2);
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button).element.tap()
        sleep(2);
        let enterReceiptDescriptionHereTextField = app.textFields["Enter receipt description here"]
        enterReceiptDescriptionHereTextField.tap()
        sleep(2);
        enterReceiptDescriptionHereTextField.typeText("F")
        sleep(2);
        
        let app2 = app
        sleep(2);
        app2/*@START_MENU_TOKEN@*/.keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2);
        enterReceiptDescriptionHereTextField.typeText("ood")
        sleep(2);
        app.textFields["Enter category of expense here"].tap()
        sleep(2);
        app2/*@START_MENU_TOKEN@*/.pickerWheels["Restaurant"].tap()/*[[".pickers.pickerWheels[\"Restaurant\"]",".tap()",".press(forDuration: 1.1);",".pickerWheels[\"Restaurant\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,1]]@END_MENU_TOKEN@*/
        sleep(20);
        app.buttons["Save Image"].tap()
        sleep(2);
        
        app.alerts["Confirm Transaction"].buttons["No"].tap()
        sleep(2);

        let moreKey = app2/*@START_MENU_TOKEN@*/.keys["more"]/*[[".keyboards",".keys[\"more, numbers\"]",".keys[\"more\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        sleep(2);
        moreKey.tap()
        sleep(2);
        app2/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2);

        let updateTransactionAlert = app.alerts["Update Transaction"]
        sleep(2);
        let enterAmountTextField = updateTransactionAlert.collectionViews.textFields["Enter amount"]
        sleep(2);
        enterAmountTextField.typeText("3")
        sleep(2);
        app2/*@START_MENU_TOKEN@*/.keys["."]/*[[".keyboards.keys[\".\"]",".keys[\".\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2);
        enterAmountTextField.typeText(".")
        sleep(2);
        app2/*@START_MENU_TOKEN@*/.keys["9"]/*[[".keyboards.keys[\"9\"]",".keys[\"9\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2);
        enterAmountTextField.typeText("9")
        sleep(2);
        app2/*@START_MENU_TOKEN@*/.keys["0"]/*[[".keyboards.keys[\"0\"]",".keys[\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(2);
        enterAmountTextField.typeText("0")
        sleep(2);
        updateTransactionAlert.buttons["Submit"].tap()
        
        sleep(40);
        let receiptsButton = tabBarsQuery.buttons["Receipts"]
        receiptsButton.tap()
        sleep(2);
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
        sleep(5);
        //app.statusBars.otherElements["2 of 5 bars, signal strength"].tap()
        app.buttons["Back"].tap()
        sleep(2);
        tabBarsQuery.buttons["Transactions"].tap()
    }
    
}
