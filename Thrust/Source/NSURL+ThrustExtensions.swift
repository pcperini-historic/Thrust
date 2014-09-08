//
//  NSURL+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 8/19/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

extension NSURL: StringLiteralConvertible {
    public class func convertFromExtendedGraphemeClusterLiteral(value: String) -> Self {
        return self(string: value)
    }
    
    public class func convertFromStringLiteral(value: String) -> Self {
        return self(string: value)
    }
}