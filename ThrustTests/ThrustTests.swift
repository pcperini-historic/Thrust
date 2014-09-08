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
    
    func testArrayEmptiness() {
        var x: [String] = []
        var y: [String] = ["a"]
        
        XCTAssertTrue(x.isEmpty, "")
        XCTAssertFalse(y.isEmpty, "")
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
        var y = ["a": "b"]
        
        x -= y
        XCTAssertEqual(x, ["c": "d"], "")
    }
    
    func testDictionaryEmptiness() {
        var x: [String: String] = [:]
        var y: [String: String] = ["a": "b"]
        
        XCTAssertTrue(x.isEmpty, "")
        XCTAssertFalse(y.isEmpty, "")
    }
    
}

class JSONTests: XCTestCase {
    func testContainers() {
        // JSONArray <-> array
        XCTAssertEqual(JSONArray().jsonString, "[]", "")
        XCTAssertFalse("[]".jsonObject == nil, "")
        
        // JSONDictionary <-> object
        XCTAssertEqual(JSONDictionary().jsonString, "{}", "")
        XCTAssertFalse("{}".jsonObject == nil, "")
    }
    
    func testValues() {
        var container: JSONArray
        
        // Bool <-> value
        container = []
        container.append(true)
        XCTAssertEqual(container.jsonString, "[true]", "")
        
        var convertedBool: Bool = ("[true]".jsonObject as? JSONArray)?.first as Bool
        XCTAssertEqual(convertedBool, true, "")
        
        // Double <-> number
        container = []
        container.append(4.5)
        XCTAssertEqual(container.jsonString, "[4.5]", "")
        
        var convertedDouble: Double = ("[4.5]".jsonObject as? JSONArray)?.first as Double
        XCTAssertEqual(convertedDouble, 4.5, "")
        
        // String <-> string
        container = []
        container.append("hello world")
        XCTAssertEqual(container.jsonString, "[\"hello world\"]", "")
        
        var convertedString: String = ("[\"hello world\"]".jsonObject as? JSONArray)?.first as String
        XCTAssertEqual(convertedString, "hello world", "")
        
        // Null <-> value
        container = []
        container.append(null)
        XCTAssertEqual(container.jsonString, "[null]", "")
        
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
        
        var expectedJSON = "{\"menu\":{\"id\":\"file\",\"value\":\"File\",\"popup\":{\"menuitem\":[{\"value\":\"New\",\"onclick\":\"CreateNewDoc()\"},{\"value\":\"Open\",\"onclick\":\"OpenDoc()\"},{\"value\":\"Close\",\"onclick\":\"CloseDoc()\"}]}}}"
        XCTAssertEqual(structure.jsonString.length, expectedJSON.length, "\(structure.jsonString)")
    }
}