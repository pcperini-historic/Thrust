//
//  CGPoint+AxisExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 8/24/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    // MARK: Accessors
    func inLineWithPoint(point: CGPoint, alongAxis axis: CGRectAxis) -> Bool {
        switch axis {
        case CGRectAxis.NeitherAxis:
            return (self.x != point.x) && (self.y != point.y)
        case CGRectAxis.XAxis & CGRectAxis.YAxis:
            return (self.x == point.x) && (self.y == point.y)
            
        case CGRectAxis.XAxis:
            return self.x == point.x
        case CGRectAxis.YAxis:
            return self.y == point.y
            
        default:
            return false
        }
    }
}