//
//  ItemTableViewCellViewModel.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol ItemCellViewModel {
    var name: String? { get }
}

struct ItemTableViewCellViewModel: ItemCellViewModel {
    
    let name: String?
    
    init(item: Item) {
        self.name = item.name
    }
    
}
