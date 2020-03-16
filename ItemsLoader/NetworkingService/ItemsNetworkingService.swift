//
//  ItemsNetworkingService.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

struct ItemsNetworkingService: NetworkingService {
    
    private let urlString: String
    private let httpMethod: HTTPMethod
    private let headers: [String: String]
    
    private let session: URLSession
    
    init() {
        self.init(urlString: "https://api.jsonbin.io/b/5e0f707f56e18149ebbebf5f/2",
                  httpMethod: .get,
                  headers: ["Content-Type": "application/json",
                            "secret-key": "$2b$10$Vr2RAD3mpzFZ6o8bPZNlgOOM0LmFLvN24IoxlELo3arTgNszX7otS"],
                  session: URLSession.shared)
    }
    
    init(urlString: String, httpMethod: HTTPMethod, headers: [String: String], session: URLSession) {
        self.urlString = urlString
        self.httpMethod = httpMethod
        self.headers = headers
        self.session = session
    }
    
    func loadData(completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.invalidURL)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = .returnCacheDataElseLoad
        
        headers.forEach { (headerTitle, headerValue) in
            request.addValue(headerValue, forHTTPHeaderField: headerTitle)
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NetworkError.noDataAvailable)
                return
            }
            guard let response = response as? HTTPURLResponse,
                200...299 ~= response.statusCode else {
                    if let badStatusCodeError = try? JSONDecoder().decode(BadStatusCodeError.self, from: data) {
                        completion(nil, badStatusCodeError)
                        return
                    }
                    completion(nil, NetworkError.invalidResponse)
                    return
            }
            completion(data, nil)
        }
        task.resume()
    }
}
