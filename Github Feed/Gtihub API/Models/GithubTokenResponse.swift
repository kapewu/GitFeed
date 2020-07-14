//
//  GithubTokenResponse.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 12/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

struct GithubTokenResponse: Codable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
    }
}
