//
//  UIViewController+Extensions.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 13/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayAlert(for error: Error) {
        layoutSafelyOnMainThread {
            if self.presentedViewController == nil {
                let alertController = UIAlertController(title: "Error occured", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true)
            }
        }
    }
    
    func layoutSafelyOnMainThread(actions: () -> Void) {
        if Thread.isMainThread {
            actions()
        } else {
            DispatchQueue.main.sync {
                actions()
            }
        }
    }
}
