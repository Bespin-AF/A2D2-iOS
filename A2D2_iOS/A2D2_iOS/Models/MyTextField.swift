//
//  MyTextField.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 4/1/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit

@IBDesignable
class MyTextView : UITextView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setDefaults()
    }
    
    func setDefaults() {
        translatesAutoresizingMaskIntoConstraints = true
        sizeToFit()
        isScrollEnabled = false
    }
}
