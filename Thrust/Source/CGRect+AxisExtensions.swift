//
//  CGRect+AxisExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 8/24/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation
import UIKit

struct CGRectAxis: RawOptionSetType {
    
    // MARK: Values
    static var NeitherAxis: CGRectAxis {
        return self(0)
    }
    
    static var XAxis: CGRectAxis {
        return self(0b0001)
    }
    
    static var YAxis: CGRectAxis {
        return self(0b0010)
    }
    
    // MARK: Properties
    private var value: UInt = 0
    
    // MARK: Initializers
    init(_ value: UInt) {
        self.value = value
    }
    
    static func fromMask(raw: UInt) -> CGRectAxis {
        return self(raw)
    }
    
    static func fromRaw(raw: UInt) -> CGRectAxis? {
        return self(raw)
    }
    
    static func convertFromNilLiteral() -> CGRectAxis {
        return self(0)
    }
    
    // MARK: Class Properties
    static var allZeros: CGRectAxis {
        return self(0)
    }
    
    // MARK: Accessors
    func toRaw() -> UInt {
        return self.value
    }
}