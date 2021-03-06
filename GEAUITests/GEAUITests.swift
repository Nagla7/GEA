//
//  GEAUITests.swift
//  GEAUITests
//
//  Created by njoool  on 29/01/2018.
//  Copyright © 2018 com.GP.ET. All rights reserved.
//

import XCTest

class GEAUITests: XCTestCase {
        
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
    
    func testRegulationsFailed() {
        
        let app = XCUIApplication()
        app.buttons["contract (2)"].tap()
        app.navigationBars["GEA.Regulation"].buttons["Add"].tap()
        app.buttons["Publish"].tap()
        app.alerts["Error"].buttons["OK"].tap()
        
    }
    
}
