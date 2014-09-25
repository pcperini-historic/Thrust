//
//  NSDataThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 7/23/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

extension NSData {
    // MARK: Properties
    /// The hexlified string description.
    var hexlifiedDescription: String {
        get {
            var description: String = self.description
            description.replace(["<", ">", " "], with: "")
            return description
        }
    }
    
    /// UTF16-length string representation. Grapheme-decomposed.
    var string: String {
        return NSString(data: self, encoding: NSUTF16StringEncoding)
    }
}