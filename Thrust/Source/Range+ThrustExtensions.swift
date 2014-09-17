//
//  Range+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 9/13/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

extension Range {
    // MARK: Properties
    /// Returns an array containing each element in the range.
    var all: [T] {
        return self.map({ $0 })
    }
    
    // MARK: Accessors
    /**
    
    Returns whether the given value is within the range.
    
    :param: element A value.
    
    :returns: True if the element is greater than or equal to the range's start index, and less than the range's end index; and false otherwise.
    
    */
    func contains(element: T) -> Bool {
        return self.all.contains(element)
    }
    
    /**
    
    Returns an intersection of this range and the given range.
    
    :example: (0 ..< 10).intersection(5 ..< 15) == 5 ..< 10
    
    :param: range A range to intersect with this range.
    
    :returns: An intersection of this range and the given range.
    
    */
    func intersection<T: Comparable>(range: Range<T>) -> Range<T> {
        var maxStartIndex: T = max(self.startIndex as T, range.startIndex) as T
        var minEndIndex: T = min(self.endIndex as T, range.endIndex) as T
        return Range<T>(start: maxStartIndex, end: minEndIndex)
    }
    
    /**
    
    Returns whether the given range intersects this range.
    
    :param: range A range to intersect with this range.
    
    :returns: true, if the intersection of the ranges is not empty, false otherwise.
    
    */
    func intersects<T: Comparable>(range: Range<T>) -> Bool {
        var intersection = self.intersection(range)
        return !intersection.isEmpty
    }
    
    /**
    
    Returns an union of this range and the given range.
    
    :example: (0 ..< 10).union(5 ..< 15) == 0 ..< 15
    
    :param: range A range to union with this range.
    
    :returns: A union of this range and the given range.
    
    */
    func union<T: Comparable>(range: Range<T>) -> Range<T> {
        var minStartIndex: T = min(self.startIndex as T, range.startIndex) as T
        var maxEndIndex: T = max(self.endIndex as T, range.endIndex) as T
        return Range<T>(start: minStartIndex, end: maxEndIndex)
    }
}