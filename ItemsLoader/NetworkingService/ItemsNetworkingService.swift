//
//  ItemsNetworkingService.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation
import Combine


protocol ItemsNetworkingClient {
    func loadItems() throws -> AnyPublisher<[Item], Error>
}

struct ItemsNetworkingService: ItemsNetworkingClient, NetworkingService {
    
    let router: NetworkRouter
    let session: URLSession
    
    init() {
        self.init(router: ItemsRouter(), session: URLSession.shared)
    }
    
    init(router: NetworkRouter, session: URLSession) {
        self.router = router
        self.session = session
    }

    func loadItems() throws -> AnyPublisher<[Item], Error> {
        do {
            let cancellable: AnyPublisher<[Item], Error> = try loadDataWithCombine()
            return cancellable
        } catch {
            throw error
        }
        
    }
   
}
