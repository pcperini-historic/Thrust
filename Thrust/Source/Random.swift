//
//  Random.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: Random Numbers
extension Int {
    // MARK: Class Accessors
    static func random() -> Int {
        return Int(arc4random())
    }
    
    static func random(r: Range<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(r.endIndex)) + UInt32(r.startIndex))
    }
}

extension Double {
    // MARK: Class Accessors
    static func random() -> Double {
        return Double(Int.random(0 ... 100)) / 100.0
    }
}

// MARK: Random Selections
protocol Random: CollectionType {
    typealias ValueType
    
    // MARK: Accessors
    var any: ValueType? { get }
    
    // MARK: Mutators
    mutating func shuffle()
}

extension Array: Random {
    typealias ValueType = T
    
    // MARK: Accessors
    var any: ValueType? {
        return (self.count == 0) ? nil : self[Int.random(0 ..< self.count)]
    }

    // MARK: Mutators
    mutating func shuffle() {
        for var i = self.count - 1; i > 0; i-- {
            let j = Int.random(0 ..< i)
            swap(&self[i], &self[j])
        }
    }
}