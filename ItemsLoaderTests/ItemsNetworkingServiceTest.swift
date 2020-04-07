//
//  ItemsNetworkingServiceTest.swift
//  ItemsLoaderTests
//
//  Created by Anastasia Rodzik on 21.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest
import Combine

class ItemsNetworkingServiceTest: XCTestCase {
    
    private var session: URLSession!
    private var cancellable: Cancellable?
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ItemsURLProtocolMock.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        session = nil
        cancellable?.cancel()
        super.tearDown()
    }

    func testDataLoading() {
        let router = ItemsRouter()
        let networkingService = ItemsNetworkingService(router: router, session: session)
        
        let promise = expectation(description: "Loading items data")
        cancellable = try? networkingService.loadItems().sink(receiveCompletion: { failure in
            switch failure {
            case .failure(let error):
                XCTFail("Items data is expected but \(String(describing: error)) was catched")
            case .finished:
                break
            }
            
        }) { items in
           promise.fulfill()
        }
        wait(for: [promise], timeout: 1)
        
    }
    
    func testBadStatusCodeError() {
        let networkingService = ItemsNetworkingService(router: BadStatusCodeRouter(), session: session)
        
        let promise = expectation(description: "Loading items data")
        cancellable = try? networkingService.loadItems().sink(receiveCompletion: { failure in
            switch failure {
                case .failure(let error):
                    if error is BadStatusCodeError {
                        promise.fulfill()
                    }
                case .finished:
                    XCTFail()
            }
        }, receiveValue: { _ in
            XCTFail("No data can be received without required header")
        })
        wait(for: [promise], timeout: 1)
        
    }
    
    func testInvalidURL() {
        let networkingService = ItemsNetworkingService(router: InvalidURLRouter(), session: session)
        
        let promise = expectation(description: "Loading items data")
        do {
            cancellable = try networkingService.loadItems().sink(receiveCompletion: { failure in
                switch failure {
                    case .failure(_):
                        XCTFail("Invalid URL error is expected")
                    case .finished:
                        break
                }
            }, receiveValue: { _ in
                XCTFail("No data can be received from invalid url")
            })
        } catch {
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 1)
    }

}
