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
    private(set) var session: ASWebAuthenticationSession?
    
    weak var delegate: GithubAuthDelegate?
    
    deinit {
        session = nil
    }
    
    public func prepareAuthenticationSession(inside viewController: LoginViewController) {
        guard let authUrl = Endpoint.authorization.request?.url else {
            delegate?.errorDidOccur(NetworkingError.invalidURL)
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
                self?.delegate?.errorDidOccur(NetworkingError.authenticationError)
            }
        }
        
        session?.presentationContextProvider = viewController
    }
    
    private func callForToken(withCode code: String) {
        guard let tokenRequest: URLRequest = Endpoint.token(code: code).request else {
            delegate?.errorDidOccur(NetworkingError.invalidURL)
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
