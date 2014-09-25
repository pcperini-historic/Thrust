//
//  UIView+AnimationExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 9/14/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation
import UIKit

/**

Animate changes to one or more views using the specified duration, delay, options, and completion handler.

This method initiates a set of animations to perform on the view. The block object in the animations parameter contains the code for animating the properties of one or more views.

During an animation, user interactions are temporarily disabled for the views being animated. If you want users to be able to interact with the views, include the UIViewAnimationOptionAllowUserInteraction constant in the options parameter.

This function is queue-safe, as it will always execute on the main queue.

:param: duration The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
:param: delay The amount of time (measured in seconds) to wait before beginning the animations. Specify a value of 0 to begin the animations immediately.
:param: options A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIViewAnimationOptions.
:param: animations A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy. This block takes no parameters and has no return value.
:param: completion A block object to be executed when the animation sequence ends. This block has no return value and takes a single Boolean argument that indicates whether or not the animations actually finished before the completion handler was called. If the duration of the animation is 0, this block is performed at the beginning of the next run loop cycle.

*/
func animate(#duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = UIViewAnimationOptions.allZeros, #animations: () -> Void, completion: ((finished: Bool) -> Void)? = nil) {
    on (Queue.main) {
        UIView.animateWithDuration(duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: completion)
    }
}

/// Overloads animate() to allow for Any-returning animations().
func animate(#duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = UIViewAnimationOptions.allZeros, #animations: () -> Any, completion: ((finished: Bool) -> Void)? = nil) {
    animate(duration: duration,
        delay: delay,
        options: options,
        animations: {animations(); return},
        completion: completion)
}

/// Overloads animate() to allow for Any-returning completion().
func animate(#duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = UIViewAnimationOptions.allZeros, #animations: () -> Void, completion: ((finished: Bool) -> Any)? = nil) {
    animate(duration: duration,
        delay: delay,
        options: options,
        animations: animations,
        completion: {completion?(finished: $0); return})
}

/// Overloads animate() to allow for Any-returning animations() and completion().
func animate(#duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = UIViewAnimationOptions.allZeros, #animations: () -> Any, completion: ((finished: Bool) -> Any)? = nil) {
    animate(duration: duration,
        delay: delay,
        options: options,
        animations: {animations(); return},
        completion: {completion?(finished: $0); return})
}
