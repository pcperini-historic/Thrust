//
//  Double+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 8/13/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: Operators
/// Exponential operator.
infix operator ** { associativity left precedence 160 }
func **(lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}

infix operator **= { precedence 90 }
func **=(inout lhs: Double, rhs: Double) {
    lhs = lhs ** rhs
}

/// Near-equivalence (more-or-less-equal) operator.
infix operator ><= {}

/// Returns true if both values are equal when rounded.
func ><=(lhs: Double, rhs: Double) -> Bool {
    return round(lhs) == round(rhs)
}