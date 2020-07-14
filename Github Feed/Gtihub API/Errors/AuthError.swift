//
//  AuthError.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 11/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

enum AuthError {
    case invalidURL
    case authenticationError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "It seems developer made a mistake when writing URL"
        case .authenticationError: return "Error occured during authentication"
        }
    }
}
