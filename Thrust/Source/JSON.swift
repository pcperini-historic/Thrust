//
//  JSON.swift
//  Thrust
//
//  Created by Patrick Perini on 8/1/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

//  Redo this whole thing to use JSONDictionary and JSONArray structs, instead of typealiases
//  that pull most of their methods from Dictionary/Array, including literal syntax
//  but avoid endless casting

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
    var jsonString: String { get }
}

typealias JSONDictionary = [String: JSON]
typealias JSONArray = [JSON]

// MARK: Functions
private func dictionaryFromValidJSON(validJSONObject: NSDictionary) -> JSONDictionary {
    var dictionary = JSONDictionary()
    for key in validJSONObject.allKeys {
        let keyString = key as String
        let value: AnyObject! = validJSONObject.objectForKey(key)
        
        switch value {
        case let value as NSNumber:
            switch String.fromCString(value.objCType)! {
            case "c", "C": // Bool
                dictionary[keyString] = value as Bool
            case "q", "l", "i", "s": // Int
                dictionary[keyString] = value as Int
            default: // Double
                dictionary[keyString] = value as Double
            }
            
        case let value as NSString:
            dictionary[keyString] = value as String
            
        case let value as NSArray:
            dictionary[keyString] = arrayFromValidJSON(value as NSArray)
        case let value as NSDictionary:
            dictionary[keyString] = dictionaryFromValidJSON(value as NSDictionary)
            
        default:
            dictionary[keyString] = null
        }
    }
    
    return dictionary
}

private func arrayFromValidJSON(validJSONObject: NSArray) -> JSONArray {
    var array = JSONArray()
    for value in validJSONObject {
        switch value {
        case let value as NSNumber:
            switch String.fromCString(value.objCType)! {
            case "c", "C": // Bool
                array.append(value as Bool)
            case "q", "l", "i", "s": // Int
                array.append(value as Int)
            default: // Double
                array.append(value as Double)
            }
            
        case let value as NSString:
            array.append(value as String)
            
        case let value as NSArray:
            array.append(arrayFromValidJSON(value as NSArray))
        case let value as NSDictionary:
            array.append(dictionaryFromValidJSON(value as NSDictionary))
            
        default:
            array.append(null)
        }
    }
    
    return array
}

extension Dictionary: JSONContainer {
    // MARK: Accessors
    private var jsonValidObject: NSDictionary {
        get {
            var jsonValidDictionary: NSMutableDictionary = NSMutableDictionary.dictionary()
            for (key, value) in self {
                let keyString = key as String
                
                switch value {
                case let value as Bool:
                    jsonValidDictionary.setValue(value, forKey: keyString)
                case let value as Int:
                    jsonValidDictionary.setValue(value, forKey: keyString)
                case let value as Double:
                    jsonValidDictionary.setValue(value, forKey: keyString)
                    
                case let value as String:
                    jsonValidDictionary.setValue(value, forKey: keyString)
                    
                case let value as JSONArray:
                    jsonValidDictionary.setValue(value.jsonValidObject, forKey: keyString)
                case let value as JSONDictionary:
                    jsonValidDictionary.setValue(value.jsonValidObject, forKey: keyString)
                    
                default:
                    jsonValidDictionary.setValue(NSNull(), forKey: keyString)
                }
            }
            
            return jsonValidDictionary
        }
    }
    
    var jsonString: String {
            return NSString(data: NSJSONSerialization.dataWithJSONObject(self.jsonValidObject,
                options: nil,
                error: nil)!,
                encoding: NSUTF8StringEncoding) ?? ""
    }
}

extension Array: JSONContainer {
    // MARK: Generators
    private static func objectFromValidJSONObject(validJSONObject: NSArray) -> JSONArray {
        return JSONArray()
    }
    
    // MARK: Accessors
    private var jsonValidObject: NSArray {
        get {
            var jsonValidArray: NSMutableArray = NSMutableArray.array()
            for value in self {
                switch value {
                case let value as Bool:
                    jsonValidArray.addObject(value)
                case let value as Int:
                    jsonValidArray.addObject(value)
                case let value as Double:
                    jsonValidArray.addObject(value)
                case let value as String:
                    jsonValidArray.addObject(value)
                    
                case let value as JSONArray:
                    jsonValidArray.addObject(value.jsonValidObject)
                case let value as JSONDictionary:
                    jsonValidArray.addObject(value.jsonValidObject)
                    
                default:
                    jsonValidArray.addObject(NSNull())
                }
            }
            
            return jsonValidArray
        }
    }
    
    var jsonString: String {
        return NSString(data: NSJSONSerialization.dataWithJSONObject(self.jsonValidObject,
            options: nil,
            error: nil)!,
            encoding: NSUTF8StringEncoding) ?? ""
    }
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
        self = jsonObject.jsonString
    }
    
    // MARK: Accessors
    var jsonObject: JSONContainer? {
        get {
            let jsonValue: AnyObject! = NSJSONSerialization.JSONObjectWithData(self.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!,
                options: NSJSONReadingOptions.AllowFragments,
                error: nil)

            if let jsonDictionary = jsonValue as? NSDictionary {
                return dictionaryFromValidJSON(jsonDictionary)
            } else if let jsonArray = jsonValue as? NSArray {
                return arrayFromValidJSON(jsonArray)
            }
            
            return nil
        }
    }
}