//
//  GradientView.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 4/1/19.
//  Copyright © 2019 Bespin. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable
    var firstColor: UIColor = UIColor(red:0.28, green:0.33, blue:0.39, alpha:1.0) {
        didSet {
            updateView()
        }
    }


    @IBInspectable
    var secondColor: UIColor = UIColor(red:0.16, green:0.20, blue:0.24, alpha:1.0) {
        didSet {
            updateView()
        }
    }


    @IBInspectable
    var isHorizontal: Bool = false {
        didSet {
            updateView()
        }
    }
    
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    override func layoutSubviews() {
        updateView()
    }


    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        if (self.isHorizontal) {
            layer.startPoint = CGPoint(x: 0, y: 0.5)
            layer.endPoint = CGPoint (x: 1, y: 0.5)
        } else {
            layer.startPoint = CGPoint(x: 0.5, y: 0)
            layer.endPoint = CGPoint (x: 0.5, y: 1)
        }
    }
}
