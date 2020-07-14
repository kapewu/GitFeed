//
//  Endpoints.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 13/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

enum Endpoint {
    case user
    case userEvents(user: String)
    case repos(query: String)
    case authorization
    case token(code: String)
    
    var pathValue: String {
        let base = "https://api.github.com"
        switch self {
        case .user:
            return base + "/user"
        case .userEvents(let user):
            return base + "/users/\(user)/events"
        case .repos(let query):
            return base + "/search/repositories?q=\(query)"
        case .authorization:
            return "https://github.com/login/oauth/authorize"
        case .token:
            return "https://github.com/login/oauth/access_token"
        }
    }
}
