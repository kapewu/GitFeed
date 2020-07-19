//
//  JSONParameterEncoder.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 19/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

public struct JSONParameterEncoder {
    public func encode(urlRequest: URLRequest, with parameters: [String : String]) throws -> URLRequest {
        var request = urlRequest
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        } catch {
            throw error
        }
    }
}
