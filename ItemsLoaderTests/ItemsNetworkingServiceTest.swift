//
//  ItemsNetworkingServiceTest.swift
//  ItemsLoaderTests
//
//  Created by Anastasia Rodzik on 21.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import XCTest

class ItemsNetworkingServiceTest: XCTestCase {
    
    private var session: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [ItemsURLProtocolMock.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        session = nil
        super.tearDown()
    }

    func testDataLoading() {
       let networkingService: NetworkingService = ItemsNetworkingService(urlString: "https://www.google.com",
                                                                          httpMethod: .get,
                                                                          headers: ["secret-key": "$2b$10$Vr2RAD3mpzFZ6o8bPZNlgOOM0LmFLvN24IoxlELo3arTgNszX7otS"],
                                                                          session: session)
        
        let promise = expectation(description: "Loading items data")
        networkingService.loadData { (data, error) in
            if data != nil {
                promise.fulfill()
            } else {
                XCTFail("Items data is expected but \(String(describing: error)) was catched")
            }
        }
        wait(for: [promise], timeout: 1)
        
    }
    
    func testBadStatusCodeError() {
        let networkingService: NetworkingService = ItemsNetworkingService(urlString: "https://www.google.com",
                                                                          httpMethod: .get,
                                                                          headers: [:],
                                                                          session: session)
        
        let promise = expectation(description: "Loading items data")
        networkingService.loadData { (data, error) in
            guard let error = error else {
                XCTFail("No data can be received without required header")
                return
            }
            if error is BadStatusCodeError {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 1)
        
    }
    
    func testInvalidURL() {
        let networkingService: NetworkingService = ItemsNetworkingService(urlString: "$%#___+?",
                                                                          httpMethod: .get,
                                                                          headers: ["secret-key": "$2b$10$Vr2RAD3mpzFZ6o8bPZNlgOOM0LmFLvN24IoxlELo3arTgNszX7otS"],
                                                                          session: session)
        
        let promise = expectation(description: "Loading items data")
        networkingService.loadData { (data, error) in
            guard data == nil else {
                XCTFail("No data can be received from invalid url")
                return
            }
            guard let error = error as? NetworkError else {
                XCTFail("Invalid URL error is expected")
                return
            }
            switch error {
            case .invalidResponse, .noDataAvailable:
                XCTFail("Invalid URL error is expected")
            case .invalidURL:
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 1)
        
    }

}
