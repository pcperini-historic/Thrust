//
//  Dictionary+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Operators
func +=<Key, Value>(inout lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) {
    for key: Key in rhs.keys {
        lhs[key] = rhs[key]
    }
}

func -=<Key, Value>(inout lhs: Dictionary<Key, Value>, rhs: Dictionary<Key, Value>) {
    for key: Key in rhs.keys {
        lhs.removeValueForKey(key)
    }
}

extension Dictionary {
    // MARK: Accessors
    var isEmpty: Bool {
        return (self.count <= 0)
    }
}