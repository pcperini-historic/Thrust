//
//  Queue.swift
//  Thrust
//
//  Created by Patrick Perini on 8/10/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

struct Queue {
    
    // MARK: Singletons
    /// A queue representing the main queue.
    static let main: Queue = Queue(dispatchQueue: dispatch_get_main_queue())
    
    /// A queue representing the default background queue.
    static let background: Queue = Queue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
    
    // MARK: Properties
    private let dispatchQueue: dispatch_queue_t
    
    // MARK: Initializers
    private init(dispatchQueue: dispatch_queue_t) {
        self.dispatchQueue = dispatchQueue
    }
    
    init(label: String) {
        let labelCString: [CChar] = label.cString ?? "".cString!
        self.init(dispatchQueue: dispatch_queue_create(labelCString, nil))
    }

    // MARK: Accessors
    /// Returns the label for this queue.
    var label: String? {
        return String.fromCString(dispatch_queue_get_label(self.dispatchQueue))
    }
}

// MARK: - Functions
/**

Executes the given block on the given queue.

:param: queue The queue on which to execute the given block
:param: block A block of code.

*/
func on(queue: Queue, block: () -> Void) {
    dispatch_async(queue.dispatchQueue, block)
}

/// Overloads on() to allow for Any-returning block().
func on(queue: Queue, block: () -> Any) {
    on(queue) {block(); return}
}