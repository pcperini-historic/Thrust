//
//  Random.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: Random Primitives
extension Int {
    // MARK: Class Accessors
    /// Returns a uniformly-distributed random integer between Int.min and Int.max, inclusive.
    static func random() -> Int {
        return self.random(Int.min ..< Int.max)
    }
    
    /// Returns a uniformly-distributed random integer in the given range.
    static func random(r: Range<Int>) -> Int {
        return Int(arc4random_uniform(UInt32(r.endIndex)) + UInt32(r.startIndex))
    }
}

extension Double {
    // MARK: Class Accessors
    /// Returns a uniformly-distributed random double between 0.0 and 1.0, inclusive.
    static func random() -> Double {
        return Double(Int.random(0 ... 100)) / 100.0
    }
    
    /**

    Returns a normally-distributed random double.

    :param: sigma The standard deviation sigma for the distribution.
    :param: mean The average value for the distribution.
    
    :returns: A normally-distributed random double.
    
    */
    static func normalized(#sigma: Double, mean: Double) -> Double {
        return sqrt(-2.0 * log(Double.random() + DBL_EPSILON)) * cos(2.0 * M_PI * Double.random()) * sigma + mean
    }
}

extension String {
    // MARK: Class Accessors
    /**
    
    Returns a randomly-built string.
    
    :param: length The length of the random string. Defaults to a random integer.
    :param: alphabet The alphabet from which to construct the string. Defaults to alphanumeric characters.
    
    :returns: A randomly-built string.
    
    */
    static func random(length: Int? = nil, alphabet: String? = nil) -> String {
        let chars: String = alphabet ?? "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var string: String = ""
        for _ in 0 ..< (length ?? Int.random()) {
            let character: String = chars[Int.random(0 ..< chars.length)]
            string += character
        }
        
        return string
    }
}

// MARK: Random Selections
protocol Random {
    typealias ValueType
    
    // MARK: Accessors
    /// Returns a random value from the collection.
    var any: ValueType? { get }
    
    // MARK: Mutators
    /// Randomizes the values' positions in the collection. Not guaranteed to be different across shuffles.
    mutating func shuffle()
}

extension Array: Random {
    // MARK: Properties
    var any: T? {
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

extension Dictionary: Random {
    // MARK: Properties
    var any: Key? {
        return self.keys.array.any
    }
    
    // MARK: Mutators
    mutating func shuffle() {
        // Since order is not guaranteed,
        // do nothing.
    }
}

extension Dictionary {
    // MARK: Accessors
    /// From a [Key: Int] dictionary, returns a random Key, weighted by the key's value.
    var anyByWeight: Key? {
        get {
            let keys: [Key] = self.keys.array
            var weightedIndices: [Int] = []
            
            for (index, key) in enumerate(keys) {
                var value: Value? = self[key]
                if let count = value as? Int {
                    for _ in 0 ..< count {
                        weightedIndices.append(index)
                    }
                }
            }
            
            if let weightedIndex: Int = weightedIndices.any {
                return keys[weightedIndex]
            } else {
                return nil
            }
        }
    }
}