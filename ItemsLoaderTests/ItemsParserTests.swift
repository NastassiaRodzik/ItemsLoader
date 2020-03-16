//
//  ItemsParserTests.swift
//  ItemsLoaderTests
//
//  Created by Anastasia Rodzik on 21.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest

class ItemsParserTests: XCTestCase {

    private var itemsParser: ItemsJSONParser!
    
    override func setUp() {
        super.setUp()
        itemsParser = ItemsJSONParser()
    }
    
    override func tearDown() {
        itemsParser = nil
        super.tearDown()
    }
    
    func testValidJSON() {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "Items", withExtension: "json") else {
            XCTFail("Missing file: Items.json")
            return
        }
        guard let jsonData = try? Data(contentsOf: url) else {
            XCTFail("Items.json has wrong format")
            return
        }
        
        let items = itemsParser.parseItems(from: jsonData)
        XCTAssert(items != nil && !items!.isEmpty, "Items should be parsed correctly")
    }
    
    func testInvalidJSON() {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "InvalidItems", withExtension: "json") else {
            XCTFail("Missing file: InvalidItems.json")
            return
        }
        guard let jsonData = try? Data(contentsOf: url) else {
            XCTFail("InvalidItems.json has wrong format")
            return
        }
        
        let items = itemsParser.parseItems(from: jsonData)
        XCTAssert(items == nil, "Items are in invalid format")
    }

}
