//
//  CGRect+AxisExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 8/24/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation
import UIKit

enum CGRectAxis {
    // MARK: Cases
    case XAxis
    case YAxis
    case BothAxes
    case NeitherAxis
    
    // MARK: Converters
    init(edge: CGRectEdge) {
        switch edge {
        case CGRectEdge.MinXEdge, CGRectEdge.MaxXEdge:
            self = XAxis
            
        case CGRectEdge.MinYEdge, CGRectEdge.MaxYEdge:
            self = YAxis
            
        default:
            self = NeitherAxis
        }
    }
}