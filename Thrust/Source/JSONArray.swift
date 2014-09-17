//
//  JSONArray.swift
//  Thrust
//
//  Created by Patrick Perini on 9/8/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

struct JSONArray: SequenceType {
    // MARK: Properties
    private var array: [JSON] = []
    
    subscript(index: Int) -> JSON {
        return self.array[index]
    }
    
    subscript(subRange: Range<Int>) -> Slice<JSON> {
        return self.array[subRange]
    }
    
    var startIndex: Int {
        return self.array.startIndex
    }
    
    var endIndex: Int {
        return self.array.endIndex
    }
    
    var count: Int {
        return self.array.count
    }
    
    var capacity: Int {
        return self.array.capacity
    }
    
    var isEmpty: Bool {
        return self.array.isEmpty
    }
    
    var first: JSON? {
        return self.array.first
    }
    
    var last: JSON? {
        return self.array.last
    }
    
    // MARK: Initializers
    init(_ array: [JSON]) {
        self.array = array
    }
    
    internal init(rawJSONObject: NSArray) {
        for value in rawJSONObject {
            switch value {
            case let value as NSNumber:
                switch String.fromCString(value.objCType)! {
                case "c", "C": // Bool
                    self.array.append(value as Bool)
                case "q", "l", "i", "s": // Int
                    self.array.append(value as Int)
                default: // Double
                    self.array.append(value as Double)
                }
                
            case let value as NSString:
                self.array.append(value as String)
                
            case let value as NSArray:
                self.array.append(JSONArray(rawJSONObject: value as NSArray))
            case let value as NSDictionary:
                self.array.append(JSONDictionary(rawJSONObject: value as NSDictionary))
                
            default:
                self.array.append(null)
            }
        }
    }
    
    // MARK: Accessors
    func generate() -> IndexingGenerator<[JSON]> {
        return self.array.generate()
    }
    
    func sorted(isOrderedBefore: (JSON, JSON) -> Bool) -> JSONArray {
        return JSONArray(self.array.sorted(isOrderedBefore))
    }
    
    // MARK: Mutators
    mutating func reserveCapacity(minimumCapacity: Int) {
        self.array.reserveCapacity(minimumCapacity)
    }
    
    mutating func append(newElement: JSON) {
        self.array.append(newElement)
    }
    
    mutating func extend(sequence: [JSON]) {
        self.array.extend(sequence)
    }
    
    mutating func removeLast() -> JSON {
        return self.array.removeLast()
    }
    
    mutating func insert(newElement: JSON, atIndex i: Int) {
        self.array.insert(newElement, atIndex: i)
    }
    
    mutating func removeAtIndex(index: Int) -> JSON {
        return self.array.removeAtIndex(index)
    }
    
    mutating func removeAll(keepCapacity: Bool = true) {
        self.array.removeAll(keepCapacity: keepCapacity)
    }
    
    mutating func sort(isOrderedBefore: (JSON, JSON) -> Bool) {
        self.array.sort(isOrderedBefore)
    }
    
    // MARK: Modifiers
    func join(elements: [JSONArray]) -> JSONArray {
        return JSONArray(self.array.join(elements.map({ $0.array })))
    }
    
    func reduce<U>(initial: U, combine: (U, JSON) -> U) -> U {
        return self.array.reduce(initial, combine: combine)
    }
    
    func map<U>(transform: (JSON) -> U) -> [U] {
        return self.array.map(transform)
    }
    
    func reverse() -> JSONArray {
        return JSONArray(self.array.reverse())
    }
    
    func filter(includeElement: (JSON) -> Bool) -> JSONArray {
        return JSONArray(self.array.filter(includeElement))
    }
}

extension JSONArray: JSONContainer {
    internal var rawJSONObject: NSArray {
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
                    jsonValidArray.addObject(value.rawJSONObject)
                case let value as JSONDictionary:
                    jsonValidArray.addObject(value.rawJSONObject)
                    
                default:
                    jsonValidArray.addObject(NSNull())
                }
            }
            
            return jsonValidArray
        }
    }
    
    var jsonString: String? {
        return NSString(data: NSJSONSerialization.dataWithJSONObject(self.rawJSONObject,
            options: nil,
            error: nil)!,
            encoding: NSUTF8StringEncoding)
    }
}

extension JSONArray: Reflectable {
    func getMirror() -> MirrorType {
        return self.array.getMirror()
    }
}

extension JSONArray: Printable, DebugPrintable {
    var description: String {
        return self.array.description
    }
    
    var debugDescription: String {
        return self.array.debugDescription
    }
}

extension JSONArray: ArrayLiteralConvertible {
    static func convertFromArrayLiteral(elements: JSON...) -> JSONArray {
        return JSONArray(elements)
    }
}

