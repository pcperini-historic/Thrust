//
//  Clamping.swift
//  Thrust
//
//  Created by Patrick Perini on 7/28/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Bounds
/// Clamps the given value to the given range.
func clamp<ValueType: Comparable>(val: ValueType, range: Range<ValueType>) -> ValueType {
    return max(min(val, range.endIndex), range.startIndex)
}

extension Int {
    /// Returns a copy of this integer, clamped to the given range.
    func clamped(range: Range<Int>) -> Int {
        return clamp(self, range)
    }
    
    /// Clamps this intenger to the given range.
    mutating func clampTo(range: Range<Int>) {
        self = self.clamped(range)
    }
}