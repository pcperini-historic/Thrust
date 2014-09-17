//
//  JSON.swift
//  Thrust
//
//  Created by Patrick Perini on 8/1/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - JSON Valid Types
protocol JSON {}
extension Bool: JSON {}
extension Int: JSON {}
extension Double: JSON {}
extension String: JSON {}

// MARK: Nulls
struct Null: JSON, Equatable {}
let null: Null = Null()
func ==(lhs: Null, rhs: Null) -> Bool {
    return true
}

// MARK: Containers
protocol JSONContainer: JSON {
    // MARK: Accessors
    var jsonString: String? { get }
}

// MARK: - JSON Conversion
protocol JSONifiable {
    // MARK: Initializers
    init(jsonObject: JSONContainer)
    
    // MARK: Accessors
    var jsonObject: JSONContainer? { get }
}

extension String: JSONifiable {
    // MARK: Initializers
    init(jsonObject: JSONContainer) {
        self = jsonObject.jsonString ?? ""
    }

    // MARK: Accessors
    var jsonObject: JSONContainer? {
        get {
            if let jsonData = self.data {
                let jsonValue: AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonData,
                    options: NSJSONReadingOptions.AllowFragments,
                    error: nil)
                
                switch jsonValue {
                case let jsonValue as NSDictionary:
                    return JSONDictionary(rawJSONObject: jsonValue)
                    
                case let jsonValue as NSArray:
                    return JSONArray(rawJSONObject: jsonValue)
                    
                default:
                    return nil
                }
            }
                
            return nil
        }
    }
}