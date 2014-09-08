//
//  Int+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 8/11/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

func **(lhs: Int, rhs: Int) -> Int {
    return Int(Double(lhs) ** Double(rhs))
}

func **=(inout lhs: Int, rhs: Int) {
    lhs = lhs ** rhs
}