//
//  ItemsViewModel.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

protocol ItemsViewModelDataSource {
    
    var networkingService: NetworkingService { get }
    var itemsParser: ItemsJSONParser { get }
    var itemsHandler: ItemsHandlerProtocol { get }
    
    var lists: [ItemsGroupedList]? { get }
    var isItemsListsAvailable: Bool { get }
    func prepareItems(completion: @escaping (String?) -> Void)
}

final class ItemsViewModel: ItemsViewModelDataSource {
    
    let networkingService: NetworkingService
    let itemsParser: ItemsJSONParser
    let itemsHandler: ItemsHandlerProtocol
    
    var lists: [ItemsGroupedList]?
    var isItemsListsAvailable: Bool {
        guard let lists = lists else {
            return false
        }
        return !lists.isEmpty
    }
    
    init() {
        networkingService = ItemsNetworkingService()
        itemsParser = ItemsJSONParser()
        itemsHandler = ItemsHandler()
    }
    
    func prepareItems(completion: @escaping (String?) -> Void) {
        
        networkingService.loadData { [weak self] (data, error) in
            guard let self = self else {
                return
            }
            guard error == nil else {
                if let localizedError = error as? LocalizedError {
                    completion(localizedError.errorDescription)
                } else {
                    completion(error?.localizedDescription)
                }
                return
            }
            guard let data = data else {
                completion(NetworkError.noDataAvailable.errorDescription)
                return
            }
            guard var items = self.itemsParser.parseItems(from: data) else {
                completion(ParserError.cannotDecodeData.errorDescription)
                return
            }
            
            let lists = self.itemsHandler.handle(&items)
            self.lists = lists
            completion(nil)
        
        }
        
    }
    
}
