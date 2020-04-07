//
//  ItemsURLProtocolMock.swift
//  ItemsLoaderTests
//
//  Created by Anastasia Rodzik on 22.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

class ItemsURLProtocolMock: URLProtocol {
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let url = request.url else {
            client?.urlProtocol(self, didFailWithError: NetworkError.invalidURL)
            return
        }
        let requiredHeader = "secret-key"
        let requiredHeaderValue = "$2b$10$Vr2RAD3mpzFZ6o8bPZNlgOOM0LmFLvN24IoxlELo3arTgNszX7otS"
        if let secretHeaderValue = request.value(forHTTPHeaderField: requiredHeader),
            secretHeaderValue == requiredHeaderValue {
            let bundle = Bundle(for: type(of: self))
            let itemsURL = bundle.url(forResource: "Items", withExtension: "json")!
            let jsonData = try! Data(contentsOf: itemsURL)
            client?.urlProtocol(self, didLoad: jsonData)
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: request.allHTTPHeaderFields)
            client?.urlProtocol(self,
                                didReceive: response!,
                                cacheStoragePolicy: .notAllowed)
        } else {
            let badStatusCodeError = BadStatusCodeError(message: "Please send a secret header")
            if let badStatusCodeData = try? JSONEncoder().encode(badStatusCodeError) {
                client?.urlProtocol(self, didLoad: badStatusCodeData)
            }
            let response = HTTPURLResponse(url: url,
                                           statusCode: 401,
                                           httpVersion: nil,
                                           headerFields: request.allHTTPHeaderFields)
            client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
