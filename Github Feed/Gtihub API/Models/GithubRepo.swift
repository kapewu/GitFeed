//
//  GithubRepo.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 13/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

struct GithubRepos: Codable {
    let items: [Repository]?
}

struct Repository: Codable {
    var name: String
    var fullName: String
    var description: String?
    var language: String?
    var license: License?
    var updatedAt: Date
    let owner: Owner
    let forksCount: Int
    let stargazersCount: Int
    let watchersCount: Int
    let openIssuesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case updatedAt = "updated_at"
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case openIssuesCount = "open_issues_count"
        case description, language, license, owner, name
    }
}

struct Owner: Codable {
    let login: String
}

struct License: Codable {
    var name: String
}
