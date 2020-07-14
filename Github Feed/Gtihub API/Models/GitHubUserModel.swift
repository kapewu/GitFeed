//
//  GitHubUserModel.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 11/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

struct GitHubUserModel: Codable {
    var login: String
    var id: Int
    var type: String
    var followers: Int
    var publicRepos: Int
    
    enum CodingKeys: String, CodingKey {
        case publicRepos = "public_repos"
        
        case login
        case id
        case type
        case followers
    }
}
