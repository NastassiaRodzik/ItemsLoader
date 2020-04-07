//
//  ItemsViewModel.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation
import Combine

protocol ItemsViewModelDataSource {
    init(networkingService: NetworkingService, itemsParser: ItemsJSONParser, itemsHandler: ItemsHandlerProtocol)
    
    var itemsSubject: CurrentValueSubject<[ItemsGroupedList], Error> { get }
    func prepareItems()
}

final class ItemsViewModel: ItemsViewModelDataSource {

    let itemsSubject: CurrentValueSubject<[ItemsGroupedList], Error> = CurrentValueSubject([])
    
    private let networkingService: NetworkingService
    private let itemsParser: ItemsJSONParser
    private let itemsHandler: ItemsHandlerProtocol
    
    private var lists: [ItemsGroupedList]?

    init(networkingService: NetworkingService, itemsParser: ItemsJSONParser, itemsHandler: ItemsHandlerProtocol){
        self.networkingService = networkingService
        self.itemsParser = itemsParser
        self.itemsHandler = itemsHandler
    }
    
    convenience init() {
        self.init(networkingService: ItemsNetworkingService(), itemsParser: ItemsJSONParser(), itemsHandler: ItemsHandler())
    }
    
    func prepareItems() {
        networkingService.loadData { [weak self] (data, error) in
            guard let self = self else {
                return
            }
            guard error == nil else {
                self.itemsSubject.send(completion: Subscribers.Completion<Error>.failure(error!))
                return
            }
            guard let data = data else {
                self.itemsSubject.send(completion: Subscribers.Completion<Error>.failure(NetworkError.noDataAvailable))
                return
            }
            guard var items = self.itemsParser.parseItems(from: data) else {
                self.itemsSubject.send(completion: Subscribers.Completion<Error>.failure(ParserError.cannotDecodeData))
                return
            }
            
            let lists = self.itemsHandler.handle(&items)
            self.lists = lists
            
            self.itemsSubject.send(lists)
            self.itemsSubject.send(completion: Subscribers.Completion<Error>.finished)
           
        }
    }
    
}
