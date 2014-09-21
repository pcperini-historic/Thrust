//
//  Array+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Functions
/**

Returns the index of the given value in the sequence.

:param: seq A sequence of equatable values.
:param: obj An Equatable value.

:returns: The index of the given value, or nil if the value is not found.

*/
func index<S: SequenceType where S.Generator.Element: Equatable>(seq: S, obj: S.Generator.Element) -> Int? {
    for (index, anObject) in enumerate(seq) {
        if (anObject as S.Generator.Element) == (obj as S.Generator.Element) {
            return index
        }
    }
    
    return nil
}

// MARK: - Operators
/// Removes the any objects in the right-hand array from the left-hand array.
func -=<T: Equatable>(inout lhs: [T], rhs: [T]) {
    lhs = lhs.filter({ !rhs.contains($0) })
}

extension Array {
    // MARK: Accessors
    /**
    
    Returns the index of the given value in the array.
    
    :param: obj An Equatable value.
    
    :returns: The index of the given value, or nil if the value is not found.
    
     */
    func index<T: Equatable>(obj: T) -> Int? {
        for (index, anObject) in enumerate(self) {
            if (anObject as T) == (obj as T) {
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
    func contains<T: Equatable>(obj: T) -> Bool {
        return self.index(obj) != nil
    }

    // MARK: Mutators
    /**
    
    Removes the given value from the array.
    
    :param: obj An Equatable value.
    
    */
    mutating func remove<T: Equatable>(obj: T) {
        self = self.filter({ ($0 as T) != (obj as T) })
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
    /**
    
    Performs the block on each object in the array.
    Inspired by Objective-C's -[NSArray makeObjectsPerformSelector:]
    
    :param: block A block that takes 1 argument: the value from this array.
    
    */
    func perform(block: (T) -> Void) {
        for obj in self {
            block(obj)
        }
    }
    
    /// Overrides perform() to allow for Any-returning block.
    func perform(block: (T) -> Any) {
        self.perform({block($0); return})
    }
}