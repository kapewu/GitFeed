//
//  LoginViewController.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 11/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    private var authSession: GithubAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authSession = GithubAuth()
        authSession?.delegate = self
        
        authSession?.prepareAuthenticationSession(inside: self)
    }
    
    deinit {
        authSession = nil
    }
    
    @IBAction func onLoginButtonClick(_ sender: UIButton) {
        authSession?.session?.start()
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return view.window!
    }
}

extension LoginViewController: GithubAuthDelegate {
    func errorDidOccur(_ error: Error) {
        displayAlert(for: error)
    }
    
    func didLoginSuccessfuly() {
        layoutSafelyOnMainThread {
            self.dismiss(animated: true)
        }
    }
}
