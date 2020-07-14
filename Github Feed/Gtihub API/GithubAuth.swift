//
//  GithubAuth.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 13/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import Foundation
import AuthenticationServices

class GithubAuth {
    private var clientId: String = #APIKEY
    private var clientSecret: String = #CLIENT SECRET
    
    private(set) var session: ASWebAuthenticationSession?
    
    weak var delegate: GithubAuthDelegate?
    
    deinit {
        session = nil
    }
    
    private func createURLRequest(for endpoint: Endpoint) -> URLRequest? {
        var urlComponents: URLComponents? = URLComponents(string: endpoint.pathValue)
        
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "client_id", value: clientId)]
        switch endpoint {
        case .token(let code):
            queryItems.append(contentsOf: [URLQueryItem(name: "client_secret", value: clientSecret),
                                           URLQueryItem(name: "code", value: code)])
        case .authorization:
            queryItems.append(URLQueryItem(name: "scope", value: "user repo"))
        default:
            break
        }
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else { return nil }
        var request = URLRequest(url: url)
        
        switch endpoint {
        case .token:
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
        default:
            break
        }
        
        return request
    }
    
    public func prepareAuthenticationSession(inside viewController: LoginViewController) {
        guard let authUrl = createURLRequest(for: .authorization)?.url else {
            delegate?.errorDidOccur(AuthError.invalidURL)
            return
        }
        
        session = ASWebAuthenticationSession(url: authUrl, callbackURLScheme: nil) { [weak self] callbackURL, error in
            if let error = error {
                self?.delegate?.errorDidOccur(error)
            } else if let url = callbackURL {
                if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
                    if let codeComponent = components.queryItems?.first(where: { $0.name == "code" })?.value {
                        self?.callForToken(withCode: codeComponent)
                        return
                    }
                }
                self?.delegate?.errorDidOccur(AuthError.authenticationError)
            }
        }
        
        session?.presentationContextProvider = viewController
    }
    
    private func callForToken(withCode code: String) {
        guard let tokenRequest: URLRequest = createURLRequest(for: .token(code: code)) else {
            delegate?.errorDidOccur(AuthError.invalidURL)
            return
        }
        
        URLSession.shared.jsonDataTask(with: tokenRequest) { (response: Result<GithubTokenResponse, Error>) in
            switch response {
            case .success(let response):
                Keychain.save(token: response.token)
                self.delegate?.didLoginSuccessfuly()
            case .failure(let error):
                self.delegate?.errorDidOccur(error)
            }
        }.resume()
    }
}

protocol GithubAuthDelegate: class {
    func errorDidOccur(_ error: Error)
    func didLoginSuccessfuly()
}
