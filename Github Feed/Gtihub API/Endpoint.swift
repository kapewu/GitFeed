//
//  Endpoints.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 13/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum Endpoint: EndpointType {
    case user
    case userEvents(user: String)
    case repos(query: String)
    case authorization
    case token(code: String)
    
    var base: URL {
        switch self {
        case .authorization, .token:
            return URL(string: "https://github.com")!
        case .repos, .user, .userEvents:
            return URL(string: "https://api.github.com")!
        }
    }
    
    var path: String {
        switch self {
        case .user:
            return "/user"
        case .userEvents(let user):
            return "/users/\(user)/events"
        case .repos:
            return "/search/repositories"
        case .authorization:
            return "/login/oauth/authorize"
        case .token:
            return "/login/oauth/access_token"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .token:
            return .post
        default:
            return .get
        }
    }
    
    var cachable: Bool {
        switch self {
        case .userEvents:
            return true
        default:
            return false
        }
    }
    
    var request: URLRequest? {
        let url = base.appendingPathComponent(path)
        var request: URLRequest? = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)
        request!.httpMethod = method.rawValue
        request!.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var parameters: [String : String] = [:]
        switch self {
        case .authorization:
            request = try? URLParameterEncoder().encode(urlRequest: request!, with: ["client_id" : GithubKeys.clientID,
                                                                                     "scope" : "repo"])
        case .token(let code):
            parameters = ["client_id" : GithubKeys.clientID,
                          "client_secret" : GithubKeys.clientSecret,
                          "code" : code]
            request = try? JSONParameterEncoder().encode(urlRequest: request!, with: parameters)
        case .repos(let query):
            request = try? URLParameterEncoder().encode(urlRequest: request!, with: ["q" : query])
            request = try? HeaderParameterInjector().injectAuthorizationToken(to: request)
        default:
            request = try? HeaderParameterInjector().injectAuthorizationToken(to: request)
        }
        
        return request
    }
}

