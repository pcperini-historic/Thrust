//
//  Array+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Operators
func -=<ValueType: Equatable>(inout lhs: [ValueType], rhs: [ValueType]) {
    for rhsObject in rhs {
        lhs.remove(rhsObject)
    }
}

extension Array {
    
    // MARK: Accessors
    var isEmpty: Bool {
        return (self.count <= 0)
    }
    
    func index<ValueType: Equatable>(obj: ValueType) -> Int? {
        for (index, anObject) in enumerate(self) {
            if (anObject as ValueType) == (obj as ValueType) {
                return index
            }
        }
        
        return nil
    }

    // MARK: Mutators
    mutating func remove<ValueType: Equatable>(obj: ValueType) {
        self = self.filter({ ($0 as ValueType) != (obj as ValueType) })
    }
}