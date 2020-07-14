//
//  RoundedImageView.swift
//  Github Feed
//
//  Created by Beniamin Idziak on 12/07/2020.
//  Copyright © 2020 Beniamin Idziak. All rights reserved.
//

import UIKit.UIImageView

@IBDesignable
class RoundedImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            
        layer.cornerRadius = cornerRadius
    }
}
