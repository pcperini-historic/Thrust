//
//  NSDate+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Operators
func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqual(rhs)
}

func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == NSComparisonResult.OrderedDescending
}

// MARK: Date + Time Interval = Date
/// Returns a date by adding the given time intervalue to the given date.
func +(lhs: NSDate, rhs: NSTimeInterval) -> NSDate {
    return lhs.dateByAddingTimeInterval(rhs)
}

/// Returns a date by subtracting the given time intervalue to the given date.
func -(lhs: NSDate, rhs: NSTimeInterval) -> NSDate {
    return lhs + -rhs
}

func +=(inout lhs: NSDate, rhs: NSTimeInterval) {
    lhs = lhs + rhs
}

func -=(inout lhs: NSDate, rhs: NSTimeInterval) {
    lhs += -rhs
}

// MARK: Date + Date = Time Interval
/// Returns the time-interval difference between two dates.
func -(lhs: NSDate, rhs: NSDate) -> NSTimeInterval {
    return lhs.timeIntervalSinceDate(rhs)
}

extension NSDate {
    // MARK: Accessors
    /**
    
    Returns the date components requested in the given calendar units.
    
    :param: calendarUnits An or-bound set of NSCalendarUnits representing which date components to return.
    
    :returns: The date components requested in the given calendar units.
    
    */
    func components(calendarUnits: NSCalendarUnit) -> NSDateComponents {
        return NSCalendar.currentCalendar().components(calendarUnits, fromDate: self)
    }
}