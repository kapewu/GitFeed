//
//  URLSession+Extensions.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 11/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation

extension URLSession {
    func jsonDataTask<T: Codable>(with request: URLRequest, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, httpResponse, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    let model = try decoder.decode(T.self, from: data)
                    completionHandler(.success(model))
                } catch {
                    print(error)
                    completionHandler(.failure(error))
                }
            } else {
                completionHandler(.failure(NetworkingError.emptyResponse))
            }
        }
    }
}
