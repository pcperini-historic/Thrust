//
//  FlowControl.swift
//  Thrust
//
//  Created by Patrick Perini on 7/23/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Flow Control
let pass: NSObject? = nil

func build<ValueType>(builder: () -> ValueType) -> ValueType {
    return builder()
}

func after(time: NSTimeInterval, block: () -> Void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), block)
}

func after(time: NSTimeInterval, block: () -> Any) {
    after(time) {block(); return}
}

func until(cond: @autoclosure () -> Bool, block: () -> Void) {
    while !cond() {
        block()
    }
}

func unless(cond: @autoclosure () -> Bool, block: () -> Void) {
    if !cond() {
        block()
    }
}

func forever(block: () -> Void) {
    while true {
        block()
    }
}