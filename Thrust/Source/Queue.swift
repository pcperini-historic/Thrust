//
//  Queue.swift
//  Thrust
//
//  Created by Patrick Perini on 8/10/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

class Queue {
    // MARK: Singletons
    private struct singletons {
        static let mainQueue: Queue = Queue(dispatchQueue: dispatch_get_main_queue())
        static let backgroundQueue: Queue = Queue(dispatchQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0))
    }
    
    /// A queue representing the main queue.
    class var main: Queue {
        return singletons.mainQueue
    }
    
    /// A queue representing the default background queue.
    class var background: Queue {
        return singletons.backgroundQueue
    }
    
    // MARK: Properties
    private let dispatchQueue: dispatch_queue_t
    
    // MARK: Initializers
    private init(dispatchQueue: dispatch_queue_t) {
        self.dispatchQueue = dispatchQueue
    }
    
    convenience init(label: String) {
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

/**

Executes the given block on the given queue.

:param: queue The queue on which to execute the given block
:param: block A block of code.

*/
func on(queue: Queue, block: () -> Any) {
    on(queue) {block(); return}
}