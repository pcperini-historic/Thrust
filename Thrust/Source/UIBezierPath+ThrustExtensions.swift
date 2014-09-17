//
//  UIBezierPath+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 9/16/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation
import UIKit

extension UIBezierPath: ArrayLiteralConvertible {
    public class func convertFromArrayLiteral(elements: CGPoint...) -> Self {
        var path = self()
        for (index, point) in enumerate(elements) {
            if index == 0 {
                path.moveToPoint(point)
            } else {
                path.addLineToPoint(point)
            }
        }
        
        return path
    }
}