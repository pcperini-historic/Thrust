//
//  Array+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Operators
/// Removes the any objects in the right-hand array from the left-hand array.
func -=<ValueType: Equatable>(inout lhs: [ValueType], rhs: [ValueType]) {
    lhs = lhs.filter({ !rhs.contains($0) })
}

extension Array {
    // MARK: Accessors
    /**
    
    Returns the index of the given value in the array.
    
    :param: obj An Equatable value.
    
    :returns: The index of the given value, or nil if the value is not found.
    
     */
    func index<ValueType: Equatable>(obj: ValueType) -> Int? {
        for (index, anObject) in enumerate(self) {
            if (anObject as ValueType) == (obj as ValueType) {
                return index
            }
        }
        
        return nil
    }
    
    /**
    
    Returns whether or not the array contains the given value.
    
    :param: obj An Equatable value.
    
    :returns: true if the value is contained in the array, false otherwise.
    
    */
    func contains<ValueType: Equatable>(obj: ValueType) -> Bool {
        return self.index(obj) != nil
    }

    // MARK: Mutators
    /**
    
    Removes the given value from the array.
    
    :param: obj An Equatable value.
    
    */
    mutating func remove<ValueType: Equatable>(obj: ValueType) {
        self = self.filter({ ($0 as ValueType) != (obj as ValueType) })
    }
    
    /**
    
    Appends the given value to the array until the array is the given length.
    
    :param: obj A value.
    :param: length The desired length of the array.
    
    */
    mutating func pad(obj: T, toLength length: Int) {
        for index in self.count ..< length {
            self.append(obj)
        }
    }
    
    // MARK: Performers
    func perform(block: (T) -> Void) {
        for obj in self {
            block(obj)
        }
    }
    
    func perform(block: (T) -> Any) {
        self.perform({block($0); return})
    }
}