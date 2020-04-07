//
//  NetworkRouter.swift
//  ItemsLoader
//
//  Created by Анастасия Ковалева on 4/7/20.
//  Copyright © 2020 Анастасия Ковалева. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkRouter {
    var method: HTTPMethod { get }
    var urlString: String { get }
    var headers: [String: String] { get }
}

extension NetworkRouter {
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = .returnCacheDataElseLoad

        headers.forEach { (headerTitle, headerValue) in
            request.addValue(headerValue, forHTTPHeaderField: headerTitle)
        }
        return request
    }
}
