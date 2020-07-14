//
//  NetworkingError.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 11/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

enum NetworkingError {
    case emptyResponse
}

extension NetworkingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Server response seems to be empty, try again!"
        }
    }
}
