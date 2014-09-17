//
//  JSONDictionary.swift
//  Thrust
//
//  Created by Patrick Perini on 9/8/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: Operators
func +=(inout lhs: JSONDictionary, rhs: JSONDictionary) {
    for key: String in rhs.keys {
        lhs[key] = rhs[key]
    }
}

func -=(inout lhs: JSONDictionary, rhs: JSONDictionary) {
    for key: String in rhs.keys {
        lhs.removeValueForKey(key)
    }
}

struct JSONDictionary: SequenceType {
    // MARK: Properties
    private var dictionary: [String: JSON] = [:]
    
    subscript(key: String) -> JSON? {
        get {
            return self.dictionary[key]
        }
        
        set {
            self.dictionary[key] = newValue
        }
    }
    
    var count: Int {
        return self.dictionary.count
    }
    
    var isEmpty: Bool {
        return self.dictionary.isEmpty
    }
    
    var keys: LazyBidirectionalCollection<MapCollectionView<[String : JSON], String>> {
        return self.dictionary.keys
    }
    
    var values: LazyBidirectionalCollection<MapCollectionView<[String : JSON], JSON>> {
        return self.dictionary.values
    }
    
    // MARK: Initializers
    init(_ dictionary: [String: JSON]) {
        self.dictionary = dictionary
    }
    
    init(_ values: [(String, JSON)]) {
        self.init(Dictionary(values))
    }
    
    internal init(rawJSONObject: NSDictionary) {
        for (key, value) in rawJSONObject {
            let keyString = key as String
            let value: AnyObject! = rawJSONObject.objectForKey(key)
            
            switch value {
            case let value as NSNumber:
                switch String.fromCString(value.objCType)! {
                case "c", "C": // Bool
                    self.dictionary[keyString] = value as Bool
                case "q", "l", "i", "s": // Int
                    self.dictionary[keyString] = value as Int
                default: // Double
                    self.dictionary[keyString] = value as Double
                }
                
            case let value as NSString:
                self.dictionary[keyString] = value as String
                
            case let value as NSArray:
                self.dictionary[keyString] = JSONArray(rawJSONObject: value as NSArray)
            case let value as NSDictionary:
                self.dictionary[keyString] = JSONDictionary(rawJSONObject: value as NSDictionary)
                
            default:
                self.dictionary[keyString] = null
            }
        }
    }
    
    // MARK: Accessors
    func generate() -> DictionaryGenerator<String, JSON> {
        return self.dictionary.generate()
    }
    
    // MARK: Mutators
    mutating func updateValue(value: JSON, forKey key: String) -> JSON? {
        return self.dictionary.updateValue(value, forKey: key)
    }
    
    mutating func removeValueForKey(key: String) -> JSON? {
        return self.dictionary.removeValueForKey(key)
    }

    mutating func removeAll(keepCapacity: Bool = true) {
        self.dictionary.removeAll(keepCapacity: keepCapacity)
    }
}

extension JSONDictionary: JSONContainer {
    internal var rawJSONObject: NSDictionary {
        get {
            var jsonValidDictionary: NSMutableDictionary = NSMutableDictionary.dictionary()
            for (key, value) in self {
                let keyString = key as String
                
                switch value {
                case let value as Bool:
                    jsonValidDictionary.setObject(value, forKey: keyString)
                case let value as Int:
                    jsonValidDictionary.setObject(value, forKey: keyString)
                case let value as Double:
                    jsonValidDictionary.setObject(value, forKey: keyString)
                    
                case let value as String:
                    jsonValidDictionary.setObject(value, forKey: keyString)
                    
                case let value as JSONArray:
                    jsonValidDictionary.setObject(value.rawJSONObject, forKey: keyString)
                case let value as JSONDictionary:
                    jsonValidDictionary.setObject(value.rawJSONObject, forKey: keyString)
                    
                default:
                    jsonValidDictionary.setObject(NSNull(), forKey: keyString)
                }
            }
            
            return jsonValidDictionary
        }
    }
    
    var jsonString: String? {
        return NSString(data: NSJSONSerialization.dataWithJSONObject(self.rawJSONObject,
            options: nil,
            error: nil)!,
            encoding: NSUTF8StringEncoding)
    }
}

extension JSONDictionary: Printable, DebugPrintable {
    var description: String {
        return self.dictionary.description
    }
    
    var debugDescription: String {
        return self.dictionary.debugDescription
    }
}

extension JSONDictionary: Reflectable {
    func getMirror() -> MirrorType {
        return self.dictionary.getMirror()
    }
}

extension JSONDictionary: DictionaryLiteralConvertible {
    static func convertFromDictionaryLiteral(elements: (String, JSON)...) -> JSONDictionary {
        return JSONDictionary(elements)
    }
}