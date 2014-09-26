//
//  Regex.swift
//  Thrust
//
//  Created by Patrick Perini on 8/19/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

struct Regex {
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
    /**
    
    Returns whether the given string matches this regex.
    
    :param: string The string to match.
    :param: options NSMatchingOptions used to match the given string.
    
    :returns: true if the string matches the regex exactly, false otherwise.
    
    */
    func doesMatch(string: String, options: NSMatchingOptions = nil) -> Bool {
        return (self.regularExpression.numberOfMatchesInString(string,
            options: options,
            range: NSMakeRange(0, string.length)) == 1)
    }
    
    /**
    
    Returns whether any substring within the given string matches this regex.
    
    :param: string The string to query.
    :param: options NSMatchingOptions used to query the given string.
    
    :returns: true if any substring within the string matches the regex, false otherwise.
    
    */
    func hasMatch(string: String, options: NSMatchingOptions = nil) -> Bool {
        return (self.regularExpression.numberOfMatchesInString(string,
            options: options,
            range: NSMakeRange(0, string.length)) >= 1)
    }
    
    /**
    
    Returns all matched capture groups in the given string.
    
    :example: "(\w+)-(\w+)".matchedCaptureGroups("lo-rem ips-um do-lor") == [["lo", "rem"], ["ips", "um"], ["do", "lor"]]
    
    :param: string The string to match.
    :param: options NSMatchingOptions used to match the given string.
    
    :returns: An array of arrays of CaptureGroups, corresponding to each capture group within each match.
    
    */
    func matchedCaptureGroups(string: String, options: NSMatchingOptions = nil) -> [[String]] {
        
        var matches: [[String]] = [[]]
        for resultObject in self.regularExpression.matchesInString(string, options: options, range: NSMakeRange(0, string.length)) {
            if let result = resultObject as? NSTextCheckingResult {
                var match: [String] = []
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

/// Allows the creation of Regexes from string literals.
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