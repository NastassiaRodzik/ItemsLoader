//
//  Item.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

struct Item: Codable {
    let id: Int
    let listId: Int
    let name: String?
}
