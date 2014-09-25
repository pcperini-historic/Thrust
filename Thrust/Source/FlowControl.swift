//
//  FlowControl.swift
//  Thrust
//
//  Created by Patrick Perini on 7/23/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Flow Control
/// A no-op object
let pass: AnyObject? = nil

/// Dispatches the given block for execution after the given time interval.
func after(time: NSTimeInterval, block: () -> Void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
}

/// Overloads after() to allow for Any-returning block().
func after(time: NSTimeInterval, block: () -> Any) {
    after(time) {block(); return}
}