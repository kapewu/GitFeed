//
//  URLParameterEncoder.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 19/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

public struct URLParameterEncoder {
    public func encode(urlRequest: URLRequest, with parameters: [String : String]) throws -> URLRequest {
        var request: URLRequest = urlRequest
        guard let url = urlRequest.url else { throw NetworkingError.invalidURL }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            request.url = urlComponents.url
        }
        
        return request
    }
}
