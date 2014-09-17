//
//  Dictionary+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Operators
/// Adds the key-value relationships from the right-hand dictionary to the left-hand dictionary.
func +=<Key, Value>(inout lhs: [Key: Value], rhs: [Key: Value]) {
    for key: Key in rhs.keys {
        lhs[key] = rhs[key]
    }
}

/// Removes the keys found in the right-hand array from the left-hand dictionary.
func -=<Key, Value>(inout lhs: [Key: Value], rhs: [Key]) {
    for key: Key in rhs {
        lhs.removeValueForKey(key)
    }
}

extension Dictionary {
    /// Initializes the dictionary from a set of 2-tuple key/values.
    init(_ values: [(Key, Value)]) {
        self = [:]
        for (key, value) in values {
            self[key] = value
        }
    }
}