//
//  UIView+AnimationExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 9/14/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    // MARK: Animators
    /**
    
    Animate changes to one or more views using the specified duration, delay, options, and completion handler.
    This method initiates a set of animations to perform on the view. The block object in the animations parameter contains the code for animating the properties of one or more views.
    This method is thread-safe, and will always execute on the main queue.
    
    :param: duration The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
    :param: delay The amount of time to wait before beginning the animations. Specify a value of 0 to begin the animations immediately.
    :param: options A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIViewAnimationOptions.
    :param: animations A block object containing the changes to commit to the views. This is where you programmatically change any animatable properties of the views in your view hierarchy.
    :param: completion A block object to be executed when the animation sequence ends.
    
    */
    class func animate(#duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = UIViewAnimationOptions.allZeros, animations: () -> Void, completion: ((finished: Bool) -> Void)? = nil) {
        on (Queue.main) {
            UIView.animateWithDuration(duration,
                delay: delay,
                options: options,
                animations: animations,
                completion: completion)
        }
    }
    
    /// Overloads animate() to allow for Any-returning animations() and completion()
    class func animate(#duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = UIViewAnimationOptions.allZeros, animations: () -> Any, completion: ((finished: Bool) -> Any)? = nil) {
        UIView.animate(duration: duration,
            delay: delay,
            options: options,
            animations: {animations(); return},
            completion: {completion?(finished: $0); return})
    }
    
    /// Overloads animate() to allow for Any-returning completion()
    class func animate(#duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = UIViewAnimationOptions.allZeros, animations: () -> Void, completion: ((finished: Bool) -> Any)? = nil) {
        UIView.animate(duration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: {completion?(finished: $0); return})
    }
    
    /// Overloads animate() to allow for Any-returning animations()
    class func animate(#duration: NSTimeInterval, delay: NSTimeInterval = 0, options: UIViewAnimationOptions = UIViewAnimationOptions.allZeros, animations: () -> Any, completion: ((finished: Bool) -> Void)? = nil) {
        UIView.animate(duration: duration,
            delay: delay,
            options: options,
            animations: {animations(); return},
            completion: completion)
    }
}