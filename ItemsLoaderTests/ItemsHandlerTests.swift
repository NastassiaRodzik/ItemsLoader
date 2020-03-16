//
//  ItemsHandlerTests.swift
//  ItemsLoaderTests
//
//  Created by Anastasia Rodzik on 21.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest

class ItemsHandlerTests: XCTestCase {

    private var itemsHandler: ItemsHandlerProtocol!
    
    override func setUp() {
        super.setUp()
        itemsHandler = ItemsHandler()
    }
    
    override func tearDown() {
        itemsHandler = nil
        super.tearDown()
    }
    
    func testEmptyItemsList() {
        var items: [Item] = []
        
        let itemsGrouped = itemsHandler.handle(&items)
        
        XCTAssert(itemsGrouped.isEmpty, "Sorted group of zero items should be empty")
    }
    
    func testUnnamedItemsList() {
        let itemWithEmptyName = Item(id: 1, listId: 1, name: "")
        let itemWithoutName = Item(id: 2, listId: 1, name: nil)
        var items: [Item] = Array(repeating: itemWithEmptyName, count: 500)
        items.append(contentsOf: Array(repeating: itemWithoutName, count: 500))
        
        let itemsGrouped = itemsHandler.handle(&items)
        
        XCTAssert(itemsGrouped.isEmpty, "Sorted group of unnamed items should be empty")
    }
    
    func testItemsGroupsCount() {
        
        let item1 = Item(id: 1, listId: 1, name: "Item 1")
        let item2 = Item(id: 2, listId: 4, name: "Item 2")
        let item3 = Item(id: 3, listId: 2, name: "Item 3")
        let item4 = Item(id: 4, listId: 2, name: "Item 4")
        let item5 = Item(id: 5, listId: 3, name: "Item 5")
        
        var items: [Item] = [item1, item2, item3, item4, item5]
        let itemsGrouped = itemsHandler.handle(&items)
        
        XCTAssert(itemsGrouped.count == 4, "There should be 4 different groups here")
    }
    
    func testItemsGroupsOrder() {
        
        let item1 = Item(id: 1, listId: 5, name: "Item 1")
        let item2 = Item(id: 2, listId: 1, name: "Item 2")
        let item3 = Item(id: 3, listId: 40, name: "Item 3")
        let item4 = Item(id: 4, listId: 3, name: "Item 4")
        let item5 = Item(id: 5, listId: 3, name: "Item 5")
        
        var items: [Item] = [item1, item2, item3, item4, item5]
        let itemsGrouped = itemsHandler.handle(&items)
        
        var previousListIdentifier: Int!
        for (index, groupedList) in itemsGrouped.enumerated() {
            if index == 0 {
                previousListIdentifier = groupedList.listId
                continue
            }
            XCTAssert(groupedList.listId > previousListIdentifier, "List Ids should be sorted ascending")
            previousListIdentifier = groupedList.listId
        }
        
    }
    
    func testItemsNamesOrder() {
        
        let item1 = Item(id: 1, listId: 5, name: "Item 20")
        let item2 = Item(id: 2, listId: 5, name: "Item 020")
        let item3 = Item(id: 3, listId: 5, name: "Item 2")
        let item4 = Item(id: 4, listId: 5, name: "Item 21")
        let item5 = Item(id: 5, listId: 5, name: "Item 05")
        
        var items: [Item] = [item1, item2, item3, item4, item5]
        let itemsGrouped = itemsHandler.handle(&items)
        
        for groupedList in itemsGrouped {
            var previousItemName: String!
            for (itemIndex, item) in groupedList.items.enumerated() {
                if itemIndex == 0 {
                    previousItemName = item.name!
                    continue
                }
                XCTAssert(item.name! > previousItemName, "Item Names should be sorted ascending")
            }
        }
        
    }
    
}
