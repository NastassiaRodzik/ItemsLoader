//
//  NetworkRouterMocks.swift
//  ItemsLoaderTests
//
//  Created by Анастасия Ковалева on 4/7/20.
//  Copyright © 2020 Анастасия Ковалева. All rights reserved.
//

import Foundation

struct BadStatusCodeRouter: NetworkRouter {
    
    let method: HTTPMethod = .get
    let urlString: String = "https://api.jsonbin.io/b/5e0f707f56e18149ebbebf5f/2"
    let headers: [String: String] = [:]
    
}

struct InvalidURLRouter: NetworkRouter {
    let method: HTTPMethod = .get
    let urlString: String = "$%#___+?"
    let headers: [String: String] = [:]
}
