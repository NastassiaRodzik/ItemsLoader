//
//  ItemsParser.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol Parser {
    associatedtype ResponseType: Codable
    
    func parseItems(from data: Data) -> [ResponseType]?
}

protocol ItemsParser: Parser where ResponseType == Item {}

struct ItemsJSONParser: ItemsParser {

    func parseItems(from data: Data) -> [Item]? {
        return try? JSONDecoder().decode([Item].self, from: data)
    }
    
}
