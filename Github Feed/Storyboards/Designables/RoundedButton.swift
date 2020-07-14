//
//  RoundedButton.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 11/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit.UIButton

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            
        layer.cornerRadius = cornerRadius
    }
}
