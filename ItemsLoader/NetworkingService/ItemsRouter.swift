//
//  ItemsRouter.swift
//  ItemsLoader
//
//  Created by Анастасия Ковалева on 4/7/20.
//  Copyright © 2020 Анастасия Ковалева. All rights reserved.
//

import Foundation

struct ItemsRouter: NetworkRouter {
    
    let method: HTTPMethod = .get
    let urlString: String = "https://api.jsonbin.io/b/5e0f707f56e18149ebbebf5f/2"
    let headers: [String: String] = ["Content-Type": "application/json",
                                     "secret-key": "$2b$10$Vr2RAD3mpzFZ6o8bPZNlgOOM0LmFLvN24IoxlELo3arTgNszX7otS"]
    
}
