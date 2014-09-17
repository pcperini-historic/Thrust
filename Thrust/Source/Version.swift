//
//  Version.swift
//  Thrust
//
//  Created by Patrick Perini on 9/13/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation
import UIKit

// MARK: Types
private enum VersionNumber: Printable, DebugPrintable, Comparable {
    case Number(Int)
    case X
    
    // MARK: Properties
    var description: String {
        get {
            switch self {
            case .Number(let value):
                return "\(value)"
                
            case .X:
                return "x"
            }
        }
    }
    
    var debugDescription: String {
        return self.description
    }
    
    // MARK: Initializers
    init(_ number: Int? = nil) {
        if number != nil {
            self = Number(number!)
        } else {
            self = X
        }
    }
}

// MARK: Operators
private func ==(lhs: VersionNumber, rhs: VersionNumber) -> Bool {
    switch lhs {
    case .Number(let lhValue):
        switch rhs {
        case .Number(let rhValue):
            return lhValue == rhValue
            
        case .X:
            return true
        }
        
    case .X:
        return true
    }
}

private func <(lhs: VersionNumber, rhs: VersionNumber) -> Bool {
    switch lhs {
    case .Number(let lhValue):
        switch rhs {
        case .Number(let rhValue):
            return lhValue < rhValue
            
        case .X:
            return false
        }
        
    case .X:
        return false
    }
}

private func -(lhs: VersionNumber, rhs: VersionNumber) -> VersionNumber {
    switch lhs {
    case .Number(let lhValue):
        switch rhs {
        case .Number(let rhValue):
            let newValue = lhValue - rhValue
            if newValue < 0 {
                return .X
            }
            
            return VersionNumber(newValue)
            
        case .X:
            return .X
        }
        
    case .X:
        return .X
    }
}

/// A semantic representation of verion numbers.
struct Version: Comparable {
    // MARK: Values
    private enum VersionNumberIndex: Int {
        case MajorVersion = 0
        case MinorVersion = 1
        case PatchVersion = 2
        
        static var count: Int {
            return 3
        }
    }
    
    // MARK: Properties
    private var majorVersion: VersionNumber
    private var minorVersion: VersionNumber
    private var patchVersion: VersionNumber
    
    // MARK: Initializers
    private init(major: VersionNumber, minor: VersionNumber, patch: VersionNumber) {
        self.majorVersion = major
        self.minorVersion = minor
        self.patchVersion = patch
    }
    
    init(major: Int?, minor: Int?, patch: Int?) {
        self.init(major: VersionNumber(major),
            minor: VersionNumber(minor),
            patch: VersionNumber(patch))
    }
    
    init(_ components: (Int, Int, Int)) {
        self.init(major: components.0, minor: components.1, patch: components.2)
    }
}

/// Allows for the creation of versions from string literals in the format "X.X.X"
extension Version: StringLiteralConvertible {
    // MARK: Types
    typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    
    // MARK: Literal Converters
    static func convertFromExtendedGraphemeClusterLiteral(value: ExtendedGraphemeClusterLiteralType) -> Version {
        return self(value)
    }
    
    static func convertFromStringLiteral(value: StringLiteralType) -> Version {
        return self(value)
    }
    
    // MARK: Initializers
    init(_ string: String) {
        var components: [Int?] = string.componentsSeparatedByString(".").map({ $0.toInt() })
        components.pad(nil, toLength: VersionNumberIndex.count)
        
        self.init(major: components[VersionNumberIndex.MajorVersion.toRaw()],
            minor: components[VersionNumberIndex.MinorVersion.toRaw()],
            patch: components[VersionNumberIndex.PatchVersion.toRaw()])
    }
}

extension Version: Printable, DebugPrintable {
    // MARK: Properties
    var description: String {
        return "\(self.majorVersion).\(self.minorVersion).\(self.patchVersion)"
    }
    
    var debugDescription: String {
        return self.description
    }
}

extension Version: Hashable {
    // MARK: Properties
    var hashValue: Int {
        return self.description.hashValue
    }
}

// MARK: Operators
func ==(lhs: Version, rhs: Version) -> Bool {
    return (lhs.majorVersion == rhs.majorVersion) && (lhs.minorVersion == rhs.minorVersion) && (lhs.patchVersion == rhs.patchVersion)
}

/// Uses sane fallback behavior to each version component.
func <(lhs: Version, rhs: Version) -> Bool {
    if lhs.majorVersion < rhs.majorVersion {
        return true
    } else if (lhs.majorVersion == rhs.majorVersion) && (lhs.minorVersion < rhs.minorVersion) {
        return true
    } else if (lhs.majorVersion == rhs.majorVersion) && (lhs.minorVersion == rhs.minorVersion) && (lhs.patchVersion < rhs.patchVersion) {
        return true
    } else {
        return false
    }
}

/// Returns the difference between two versions. If the right-hand version is ahead, it is considered to be "x" versions ahead.
func -(lhs: Version, rhs: Version) -> Version {
    return Version(major: lhs.majorVersion - rhs.majorVersion,
        minor: lhs.minorVersion - rhs.minorVersion,
        patch: lhs.patchVersion - rhs.patchVersion)
}

/// Returns true if the versions' are equal in major and minor scope.
func ><=(lhs: Version, rhs: Version) -> Bool {
    return (lhs.majorVersion == rhs.majorVersion) && (lhs.minorVersion == rhs.minorVersion)
}

// MARK: App Extensions
extension UIApplication {
    // MARK: Properties
    /// Returns the app's version number as a Version value.
    var version: Version? {
        get {
            if let versionString = (NSBundle.mainBundle().infoDictionary["CFBundleShortVersionString"] as? NSString) as? String {
                return Version(versionString)
            } else {
                return nil
            }
        }
    }
    
    /// Returns the app's build number as a string.
    var build: String? {
        return NSBundle.mainBundle().infoDictionary["CFBundleVersion"] as? NSString
    }
}
