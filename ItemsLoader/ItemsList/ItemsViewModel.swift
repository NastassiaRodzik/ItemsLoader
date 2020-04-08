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
    var itemsSubject: CurrentValueSubject<[ItemsGroupedList], Error> { get }
    func prepareItems()
}

final class ItemsViewModel: ItemsViewModelDataSource {

    let itemsSubject: CurrentValueSubject<[ItemsGroupedList], Error> = CurrentValueSubject([])
    
    private let networkingService: ItemsNetworkingClient
    private let itemsHandler: ItemsHandlerProtocol
    
    private var networkSubscriber: Cancellable?

    init(networkingService: ItemsNetworkingClient, itemsHandler: ItemsHandlerProtocol){
        self.networkingService = networkingService
        self.itemsHandler = itemsHandler
    }
    
    convenience init() {
        self.init(networkingService: ItemsNetworkingService(), itemsHandler: ItemsHandler())
    }
    
    func prepareItems() {
        do {
            networkSubscriber = try networkingService.loadItems().sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else {
                        return
                    }
                    switch completion {
                    case .failure(let error):
                        self.itemsSubject.send(completion: Subscribers.Completion<Error>.failure(error))
                    case .finished:
                        self.networkSubscriber?.cancel()
                    }
                }, receiveValue: { [weak self] items in
                    guard let self = self else {
                        return
                    }
                    var itemsCopy = items
                    let lists = self.itemsHandler.handle(&itemsCopy)
            
                    self.itemsSubject.send(lists)
                    self.itemsSubject.send(completion: Subscribers.Completion<Error>.finished)
                    self.networkSubscriber?.cancel()
                })
        } catch {
            itemsSubject.send(completion: Subscribers.Completion<Error>.failure(error))
        }
        
    }
    
}
