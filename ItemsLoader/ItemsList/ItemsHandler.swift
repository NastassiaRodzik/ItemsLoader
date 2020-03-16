//
//  ItemsHandler.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

typealias ItemsGroupedList = (listId: Int, items: [ItemTableViewCellViewModel])

protocol ItemsHandlerProtocol {
    func handle(_ items: inout [Item]) -> [ItemsGroupedList]
}

struct ItemsHandler: ItemsHandlerProtocol {
    
    func handle(_ items: inout [Item]) -> [ItemsGroupedList] {
        
        items.removeAll(where: { $0.name == nil || $0.name!.isEmpty })
        let groupedItems = Dictionary(grouping: items, by: { $0.listId })
        
        let groupedItemsSortedByListId = groupedItems.sorted { $0.0 < $1.0 }
        
        let groupedItemsWithSortedNames = groupedItemsSortedByListId.map { tuple in
            (tuple.key, tuple.value.sorted(by: { $0.name! < $1.name! }))
        }
        let itemsGroupedList = groupedItemsWithSortedNames.map { (listId, items) -> ItemsGroupedList in
            (listId, items.map({ItemTableViewCellViewModel(item: $0)}))
        }
        return itemsGroupedList
    }
    
}
