//
//  NetworkingService.swift
//  ItemsLoader
//
//  Created by Anastasia Rodzik on 20.02.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkingService {
    init(urlString: String, httpMethod: HTTPMethod, headers: [String: String], session: URLSession)
    func loadData(completion: @escaping (Data?, Error?) -> Void)
}
