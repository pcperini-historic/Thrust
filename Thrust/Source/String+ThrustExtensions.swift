//
//  String+ThrustExtensions.swift
//  Thrust
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

func ><=(lhs: String, rhs: String) -> Bool {
    return lhs.lowercaseString == rhs.lowercaseString
}

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
    var length: Int {
        return self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
    }
    
    var cString: [CChar]? {
        return self.cStringUsingEncoding(NSUTF8StringEncoding)
    }
    
    var data: NSData? {
        return self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    }
    
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
    
    func localized(fallback: String? = nil, comment: String = "") -> String {
        if fallback != nil {
            return NSLocalizedString(self, value: fallback!, comment: comment)
        } else {
            return NSLocalizedString(self, comment: comment)
        }
    }
    
    // MARK: Mutators
    mutating func replace(string: String, with replacement: String) {
        let startIndex = advance(self.startIndex, 0)
        let endIndex = advance(startIndex, self.length)
        
        self = self.stringByReplacingOccurrencesOfString(string,
            withString: replacement,
            options: nil,
            range: Range(start: startIndex, end: endIndex))
    }
    
    mutating func replace(strings: [String], with replacement: String) {
        for string in strings {
            self.replace(string, with: replacement)
        }
    }
}