//
//  ItemsLoaderUITests.swift
//  ItemsLoaderUITests
//
//  Created by Anastasia Rodzik on 16.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest

class ItemsLoaderUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        
        XCUIApplication().launch()
    }
    
    func testItemsTableVisibility() {
        let itemsTableView = XCUIApplication().tables["ItemsTableView"]
        XCTAssertTrue(itemsTableView.isEnabled)
    }
    
    func testItemsTableHasData() {
        let itemsTableView = XCUIApplication().tables["ItemsTableView"]
        
        let itemNameLabel = itemsTableView.cells.staticTexts["ItemNameLabel"].firstMatch
        XCTAssertTrue(itemNameLabel.waitForExistence(timeout: 15))
        
    }

}
