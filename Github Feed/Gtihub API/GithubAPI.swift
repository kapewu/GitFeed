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
    
    func performRequest<T: Codable>(for endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> Void) {
        guard let request = endpoint.request else { return }
        if endpoint.cachable {
            if shouldUseCache(for: request) {
                let cache = URLCache.shared.cachedResponse(for: request)!
                let result: Result<T, Error> = decodeEventsSynchronouslyFromCache(cache.data)
                completionHandler(result)
                return
            }
        }
        URLSession.shared.jsonDataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    private func shouldUseCache(for request: URLRequest) -> Bool {
        guard let cache = URLCache.shared.cachedResponse(for: request) else { return false }
        if Reachability.isConnectedToNetwork() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZZZ"
            if let response = cache.response as? HTTPURLResponse, let dateRaw = response.allHeaderFields["Date"] as? String, let date = dateFormatter.date(from: dateRaw) {
                if Date().timeIntervalSince(date) <= 300 {
                    return true
                }
            }
            return false
        } else {
            return true
        }
    }
    
    private func decodeEventsSynchronouslyFromCache<T : Codable>(_ cache: Data) -> Result<T, Error> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let userModel = try decoder.decode(T.self, from: cache)
            return .success(userModel)
        } catch {
            return .failure(error)
        }
    }
}
