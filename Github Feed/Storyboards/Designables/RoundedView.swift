//
//  RoundedView.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 12/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit.UIView

@IBDesignable class RoundedView: UIView {}
@IBDesignable class RoundedButton: UIButton {}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
