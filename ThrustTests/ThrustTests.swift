//
//  ThrustTests.swift
//  ThrustTests
//
//  Created by Patrick Perini on 7/22/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import XCTest
import CoreGraphics

// MARK: - Array
class ThrustArrayTests: XCTestCase {
    
    func testArraySubtraction() {
        var x = ["a", "b", "c"]
        var y = ["a", "c"]
        
        x -= y
        XCTAssertEqual(x, ["b"], "")
    }
    
    func testArrayIndexAccess() {
        var x = ["a", "b", "c'"]
        
        XCTAssertEqual(x.index("a")!, 0, "")
        XCTAssertNil(x.index("z"), "")
    }
    
    func testArrayObjectRemoval() {
        var x = ["a", "b", "c"]
        x.remove("b")
        
        XCTAssertEqual(x, ["a", "c"], "")
    }
}

class ThrustDictionaryTests: XCTestCase {
    
    func testDictionaryAddition() {
        var x = ["a": "b"]
        var y = ["c": "d"]
        
        x += y
        XCTAssertEqual(x, ["a": "b", "c": "d"], "")
    }
    
    func testDictionarySubtraction() {
        var x = ["a": "b", "c": "d"]
        var y = ["a"]
        
        x -= y
        XCTAssertEqual(x, ["c": "d"], "")
    }
}

class ThrustRangeTests: XCTestCase {    
    func testRangeAll() {
        var r = 0 ..< 5
        XCTAssertEqual(r.all, [0, 1, 2, 3, 4], "")
    }
    
    func testRangeContains() {
        var r = 0 ..< 5
        XCTAssertTrue(r.contains(3), "")
        XCTAssertFalse(r.contains(5), "")
    }
    
    func testRangeIntersections() {
        var r1 = 0 ..< 5
        var r2 = 3 ..< 10
        
        XCTAssertEqual(r1.intersection(r2), 3 ..< 5, "")
        XCTAssertTrue(r1.intersects(r2), "")
    }
    
    func testRangeUnion() {
        var r1 = 0 ..< 2
        var r2 = 2 ..< 5
        
        XCTAssertEqual(r1.union(r2), 0 ..< 5, "")
    }
}

class JSONTests: XCTestCase {
    func testContainers() {
        // JSONArray <-> array
        var array: JSONArray = []
        XCTAssertEqual(array.jsonString!, "[]", "")
        XCTAssertFalse("[]".jsonObject == nil, "")
        
        // JSONDictionary <-> object
        var dictionary: JSONDictionary = [:]
        XCTAssertEqual(dictionary.jsonString!, "{}", "")
        XCTAssertFalse("{}".jsonObject == nil, "")
    }
    
    func testValues() {
        var container: JSONArray
        
        // Bool <-> value
        container = [true]
        XCTAssertEqual(container.jsonString!, "[true]", "")
        
        var convertedBool: Bool = ("[true]".jsonObject as? JSONArray)?.first as Bool
        XCTAssertEqual(convertedBool, true, "")
        
        // Double <-> number
        container = [4.5]
        XCTAssertEqual(container.jsonString!, "[4.5]", "")
        
        var convertedDouble: Double = ("[4.5]".jsonObject as? JSONArray)?.first as Double
        XCTAssertEqual(convertedDouble, 4.5, "")
        
        // String <-> string
        container = ["hello world"]
        XCTAssertEqual(container.jsonString!, "[\"hello world\"]", "")
        
        var convertedString: String = ("[\"hello world\"]".jsonObject as? JSONArray)?.first as String
        XCTAssertEqual(convertedString, "hello world", "")
        
        // Null <-> value
        container = [null]
        XCTAssertEqual(container.jsonString!, "[null]", "")
        
        var convertedNull: Null = ("[null]".jsonObject as? JSONArray)?.first as Null
        XCTAssertEqual(convertedNull, null, "")
    }
    
    func testNestibility() {
        var structure = [
            "menu": [
                "id": "file",
                "value": "File",
                "popup": [
                    "menuitem": [
                        [
                            "value": "New",
                            "onclick": "CreateNewDoc()"
                        ] as JSONDictionary,
                        [
                            "value": "Open",
                            "onclick": "OpenDoc()"
                        ] as JSONDictionary,
                        [
                            "value": "Close",
                            "onclick": "CloseDoc()"
                        ] as JSONDictionary
                    ] as JSONArray
                ] as JSONDictionary
            ] as JSONDictionary
        ] as JSONDictionary
        
        let expectedJSON = "{\"menu\":{\"id\":\"file\",\"value\":\"File\",\"popup\":{\"menuitem\":[{\"value\":\"New\",\"onclick\":\"CreateNewDoc()\"},{\"value\":\"Open\",\"onclick\":\"OpenDoc()\"},{\"value\":\"Close\",\"onclick\":\"CloseDoc()\"}]}}}"
        XCTAssertEqual(structure.jsonString!.length, expectedJSON.length, "\(structure.jsonString)")
    }
}

class VerionTests: XCTestCase {
    func testEquality() {
        var v1: Version = "0.1.0"
        var v2: Version = "0.1.0"
        XCTAssertEqual(v1, v2, "")
    }
    
    func testComparability() {
        var v1: Version = "0.1.0"
        var v2: Version = "0.1.1"
        XCTAssertTrue(v2 > v1, "")
    }
    
    func testDifferences() {
        var v1: Version = "5.4.9"
        var v2: Version = "6.3.2"
        
        XCTAssertEqual(v2 - v1, ("1.1.x" as Version), "")
    }
}