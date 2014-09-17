//
//  String+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

/// Returns true if both string's lowercase values are equal.
func ><=(lhs: String, rhs: String) -> Bool {
    return lhs.lowercaseString == rhs.lowercaseString
}

/// Repeats a string N number of times.
func *(lhs: String, rhs: Int) -> String {
    var result: String = ""
    for _ in 0 ..< rhs {
        result += lhs
    }
    
    return result
}

func *=(inout lhs: String, rhs: Int) {
    lhs = lhs * rhs
}

extension String {
    // MARK: Properties
    /// UTF16-length of the string.
    var length: Int {
        return self.lengthOfBytesUsingEncoding(NSUTF16StringEncoding)
    }
    
    var cString: [CChar]? {
        return self.cStringUsingEncoding(NSUTF16StringEncoding)
    }
    
    /// UTF16-encoded data representation of the string.
    var data: NSData? {
        return self.dataUsingEncoding(NSUTF16StringEncoding, allowLossyConversion: false)
    }
    
    /// Whether the string has any characters other than whitespace.
    var hasContent: Bool {
        return !("^(\\s*)$" as Regex).doesMatch(self)
    }
    
    // MARK: Accessors
    subscript(i: Int) -> String {
        return self[i ... i]
    }
    
    subscript(r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    subscript(r: NSRange) -> String {
        return self[r.location ..< (r.location + r.length)]
    }
    
    /**
    
    Returns a localized string, using the main bundle.
    
    :param: fallback An optional string to fall back to, if no localization is found.
    :param: comment A comment to attach to the localization.
    
    :returns: The localized string corresponding to this string.
    
    */
    func localized(fallback: String? = nil, comment: String = "") -> String {
        if fallback != nil {
            return NSLocalizedString(self, value: fallback!, comment: comment)
        } else {
            return NSLocalizedString(self, comment: comment)
        }
    }
    
    // MARK: Mutators
    /**
    
    Replaces all occurences of the given string with the given replacement.
    
    :param: string The string to replace.
    :param: replacement The string with which to replace.
    
    */
    mutating func replace(string: String, with replacement: String) {
        let startIndex = advance(self.startIndex, 0)
        let endIndex = advance(startIndex, self.length)
        
        self = self.stringByReplacingOccurrencesOfString(string,
            withString: replacement,
            options: nil,
            range: Range(start: startIndex, end: endIndex))
    }
    
    /**
    
    Replaces all occurences of the given strings with the given replacement.
    
    :param: strings The strings to replace.
    :param: replacement The string with which to replace.
    
    */
    mutating func replace(strings: [String], with replacement: String) {
        for string in strings {
            self.replace(string, with: replacement)
        }
    }
}