//
//  MyButton.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 11/16/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit

@IBDesignable class  MyButton : UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
        updateButtonColors()
    }
    
    @IBInspectable var rounded: Bool = true {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? 20 : 0
    }
    
    func updateButtonColors() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
    }
}
