//
//  GithubAPI.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 11/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

class GithubAPI: NSObject {
    private var accessToken: String? {
        return Keychain.loadToken()
    }
    
    private func createURLRequest(for endpoint: Endpoint) -> URLRequest? {
        guard let url = URL(string: endpoint.pathValue) else { return nil }
        var request = URLRequest(url: url)
        
        guard let accessToken = Keychain.loadToken() else { return nil }
        let headerValue = String(format: "Token %@", accessToken)
        request.addValue(headerValue, forHTTPHeaderField: "Authorization")
        
        switch endpoint {
        case .user:
            request.cachePolicy = .reloadIgnoringLocalCacheData
        default:
            break
        }
        
        return request
    }
    
    func getLoggedUserData(completionHandler: @escaping (Result<GitHubUserModel, Error>) -> Void) {
        if let request = createURLRequest(for: .user) {
            URLSession.shared.jsonDataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
    
    func getFeedData(for user: String, completionHandler: @escaping (Result<[GithubEvent], Error>) -> Void) {
        if let request = createURLRequest(for: .userEvents(user: user)) {
            if let cache = URLCache.shared.cachedResponse(for: request) {
                if shouldUseCache(cache) {
                    completionHandler(decodeEventsSynchronouslyFromCache(cache.data))
                } else {
                    URLSession.shared.jsonDataTask(with: request, completionHandler: completionHandler).resume()
                }
            } else {
                URLSession.shared.jsonDataTask(with: request, completionHandler: completionHandler).resume()
            }
        }
    }
    
    func getCurrentUserData(completionHandler: @escaping (Result<GitHubUserModel, Error>) -> Void) {
        if let request = createURLRequest(for: .user) {
            URLSession.shared.jsonDataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
    
    func getRepositoryData(for query: String, completionHandler: @escaping (Result<GithubRepos, Error>) -> Void) {
        if let request = createURLRequest(for: .repos(query: query)) {
            URLSession.shared.jsonDataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
    
    private func shouldUseCache(_ cache: CachedURLResponse) -> Bool {
        if Reachability.isConnectedToNetwork() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZZZ"
            if let response = cache.response as? HTTPURLResponse, let dateRaw = response.allHeaderFields["Date"] as? String, let date = dateFormatter.date(from: dateRaw) {
                if Date().timeIntervalSince(date) > 300 {
                    return false
                }
            }
            return false
        } else {
            return true
        }
    }
    
    private func decodeEventsSynchronouslyFromCache(_ cache: Data) -> Result<[GithubEvent], Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let userModel = try decoder.decode([GithubEvent].self, from: cache)
            return .success(userModel)
        } catch {
            return .failure(error)
        }
    }
    
    
}
