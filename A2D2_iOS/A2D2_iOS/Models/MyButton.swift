//
//  MyButton.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 11/16/18.
//  Copyright © 2018 Bespin. All rights reserved.
//

import UIKit

@IBDesignable
class  MyButton : UIButton {
    let defaultColor: UIColor = UIColor(red:0.45, green:0.51, blue:0.57, alpha:1.0)
    @IBInspectable var goodColor: UIColor = UIColor(red:0.45, green:0.51, blue:0.57, alpha:1.0)
    @IBInspectable var badColor: UIColor = UIColor(red:0.45, green:0.51, blue:0.57, alpha:1.0)
    @IBInspectable var color: UIColor = UIColor(red:0.45, green:0.51, blue:0.57, alpha:1.0) {
        didSet{
            updateButtonColors()
        }
    }
    
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
        layer.cornerRadius = rounded ? 25 : 0
    }
    
    func updateButtonColors() {
        layer.backgroundColor = color.cgColor
    }
}
