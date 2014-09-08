//
//  Regex.swift
//  Thrust
//
//  Created by Patrick Perini on 8/19/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

struct Regex {
    
    // MARK: Types
    typealias CaptureGroup = String
    
    // MARK: Properties
    private let regularExpression: NSRegularExpression
    private let errorPointer: NSErrorPointer
    var error: NSError? {
        return errorPointer.memory
    }
    
    // MARK: Initializers
    init(pattern: String, options: NSRegularExpressionOptions = nil) {
        self.errorPointer = NSErrorPointer()
        self.regularExpression = NSRegularExpression(pattern: pattern,
            options: options,
            error: self.errorPointer)
    }
    
    // MARK: Accessors
    func doesMatch(string: String, options: NSMatchingOptions = nil) -> Bool {
        return (self.regularExpression.numberOfMatchesInString(string,
            options: options,
            range: NSMakeRange(0, string.length)) == 1)
    }
    
    func hasMatch(string: String, options: NSMatchingOptions = nil) -> Bool {
        return (self.regularExpression.numberOfMatchesInString(string,
            options: options,
            range: NSMakeRange(0, string.length)) >= 1)
    }
    
    func matchedCaptureGroups(string: String, options: NSMatchingOptions = nil) -> [[CaptureGroup]] {
        
        var matches: [[CaptureGroup]] = [[]]
        for resultObject in self.regularExpression.matchesInString(string, options: options, range: NSMakeRange(0, string.length)) {
            if let result = resultObject as? NSTextCheckingResult {
                var match: [CaptureGroup] = []
                for index in 0 ..< self.regularExpression.numberOfCaptureGroups {
                    let matchRange = result.rangeAtIndex(index + 1)
                    match.append(string[matchRange])
                }
                matches.append(match)
            }
        }
        
        return matches
    }
}

extension Regex: StringLiteralConvertible {
    
    // MARK: Types
    typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    
    // MARK: Converters
    static func convertFromExtendedGraphemeClusterLiteral(value: ExtendedGraphemeClusterLiteralType) -> Regex {
        return self(pattern: value)
    }
    
    static func convertFromStringLiteral(value: StringLiteralType) -> Regex {
        return self(pattern: value)
    }
}