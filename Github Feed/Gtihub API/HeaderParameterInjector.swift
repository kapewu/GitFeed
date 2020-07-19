//
//  HeaderParameterInjector.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 19/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

public struct HeaderParameterInjector {
    public func injectAuthorizationToken(to request: URLRequest?) throws -> URLRequest {
        guard let accessToken = Keychain.loadToken() else { throw NetworkingError.authenticationError }
        guard var request = request else { throw NetworkingError.invalidURL }
        let headerValue = String(format: "Token %@", accessToken)
        request.addValue(headerValue, forHTTPHeaderField: "Authorization")
        return request
    }
}
