//
//  CGRect+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 8/24/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    
    private enum Corner {
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    
    // MARK: Properties
    var center: CGPoint {
        return CGPoint(x: CGRectGetMidX(self), y: CGRectGetMidY(self))
    }
    
    var topLeft: CGPoint {
        return self.pointForCorner(.TopLeft)
    }
    
    var topRight: CGPoint {
        return self.pointForCorner(.TopRight)
    }
    
    var bottomLeft: CGPoint {
        return self.pointForCorner(.BottomLeft)
    }
    
    var bottomRight: CGPoint {
        return self.pointForCorner(.BottomRight)
    }
    
    // MARK: Accessors
    private func pointForCorner(corner: Corner) -> CGPoint {
        switch corner {
        case .TopLeft:
            return CGPoint(x: CGRectGetMinX(self), y: CGRectGetMinY(self))
        case .TopRight:
            return CGPoint(x: CGRectGetMaxX(self), y: CGRectGetMinY(self))
        case .BottomLeft:
            return CGPoint(x: CGRectGetMinX(self), y: CGRectGetMaxY(self))
        case .BottomRight:
            return CGPoint(x: CGRectGetMaxX(self), y: CGRectGetMaxY(self))
        }
    }
    
    func pointIsCentered(point: CGPoint, alongAxis axis: CGRectAxis) -> Bool {
        return point.inLineWithPoint(self.center, alongAxis: axis)
    }
}