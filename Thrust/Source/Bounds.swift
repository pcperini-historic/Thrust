//
//  Bounds.swift
//  Thrust
//
//  Created by Patrick Perini on 7/28/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Bounds
/// Binds the given value to the given range.
func bound<ValueType: Comparable>(val: ValueType, range: Range<ValueType>) -> ValueType {
    return max(min(val, range.endIndex), range.startIndex)
}

extension Int {
    /// Returns a copy of this integer, bounded to the given range.
    func bounded(range: Range<Int>) -> Int {
        return bound(self, range)
    }
    
    /// Binds this intenger to the given range.
    mutating func bind(range: Range<Int>) {
        self = self.bounded(range)
    }
}