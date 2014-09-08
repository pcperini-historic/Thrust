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
func +(lhs: NSDate, rhs: NSTimeInterval) -> NSDate {
    return lhs.dateByAddingTimeInterval(rhs)
}

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
func -(lhs: NSDate, rhs: NSDate) -> NSTimeInterval {
    return lhs.timeIntervalSinceDate(rhs)
}

extension NSDate {
    // MARK: Accessors
    func components(calendarUnits: NSCalendarUnit) -> NSDateComponents {
        return NSCalendar.currentCalendar().components(calendarUnits, fromDate: self)
    }
}