//
//  Logic.swift
//  Thrust
//
//  Created by Patrick Perini on 7/28/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Bounds
func bound<ValueType: Comparable>(val: ValueType, range: Range<ValueType>) -> ValueType {
    return max(min(val, range.endIndex), range.startIndex)
}

extension Int {
    func bounded(range: Range<Int>) -> Int {
        return bound(self, range)
    }
    
    mutating func bind(range: Range<Int>) {
        self = self.bounded(range)
    }
    
    func boundIn(range: Range<Int>) -> Bool {
        return (self >= range.startIndex) && (self < range.endIndex)
    }
}

// MARK: - Iteration
extension Range {
    var all: [T] {
        get {
            var all: [T] = []
            for i in self {
                all.append(i)
            }
            return all
        }
    }
}