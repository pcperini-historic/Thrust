//
//  UIView+InterfaceBuilderExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 9/19/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension UIView {
    // MARK: Properties
    /// The color of the view's border. Defaults to black. Animatable.
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(CGColor: self.layer.borderColor)
        }
        
        set {
            self.layer.borderColor = newValue.CGColor
        }
    }
    
    /// The width of the view's border. Defaults to 0. Animatable.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    /// The radius of the view's border's corners. Defaults to 0. Animatable.
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}