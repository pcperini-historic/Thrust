![Thrust: Necessary for Flight](https://raw.githubusercontent.com/pcperini/Thrust/master/thrust_logo.png)

Thrust is a multi-purpose library for Swift, used to make simple operations in the language more sane.

## Features

- [x] Simplified array querying
- [x] NSObject <-> Literal bridging
- [x] Elegant Queue access
- [x] Basic HTTP querying
- [x] JSON conversion
- [x] Random number generation
- [x] Additional convenience operators
- [x] Comprehensive Unit Test Coverage
- [x] Complete Documentation

## Requirements

- iOS 7.0+ / Mac OS X 10.9+
- Xcode 6.0

## Documentation

### Functions

```swift
animate(duration: NSTimeInterval, animations: () -> Void)

after(time: NSTimeInterval, block: () -> Void)

index(seq: Sequence, obj: Element) -> Int?
comp(seq: Sequence, comp: (Element, Element) -> Bool)
max(seq: Sequence) -> Element?
min(seq: Sequence) -> Element?

clamp(val: Element, range: Range<Element>) -> Element
```

### General Extensions

```swift
Array {
    any: Element?
    index(obj: Element) -> Int?
    contains(obj: Element) -> Bool
    remove(obj: Element)
    pad(obj: Element toLength: Int)
    perform(block: (Element) -> Void)
    shuffle()
}

Dictionary {
    any: Key?
    anyByWeight: Key?
}

Range {
    all: [Element]
    contains(element: Element) -> Bool
    intersection(range: Range<Element>) -> Range<Element>
    intersects(range: Range<Element>) -> Bool
    union(range: Range<Element>) -> Range<Element>
}

NSData {
    hexlifiedDescription: String
    string: String
}

NSDate {
    components(calendarUnits: NSCalendarUnit) -> NSDateComponents
}

String {
    length: Int
    cString: [CChar]?
    data: NSData?
    hasContent: Bool
    localized() -> String
    replace(string: String with: String)
    random() -> String
}

Int {
    clamped(range: Range<Int>) -> Int
    clampTo(range: Range<Int>)
    random() -> Int
    random(r: Range<Int>) -> Int
}

Double {
    random() -> Double
    normalized(sigma: Double, mean: Double) -> Double
}

UIApplication {
    version: Version?
    build: String?
}
```

### Operators

```swift
[Element] -= [Element]

[Key: Value] += [Key: Value]
[Key: Value] -= [Key]

Double ** Double = Double
Double **= Double
Double ><= Double = Bool

Int ** Int = Int
Int **= Int

NSDate == NSDate = Bool
NSDate > NSDate = Bool
NSDate + NSTimeInterval = NSDate
NSDate - NSTimeInterval = NSDate
NSDate += NSTimeInterval
NSDate -= NSTimeInterval
NSDate - NSDate = NSTimeInterval

String ><= String = Bool
String * String = String
String *= String
String[Int] -> String
String[Range<Int>] -> String
```

### Literal Conversions

```swift
"http://github.com/pcperini/Thrust" as NSURL
[CGPoint(x: 0, y: 0), CGPoint(x: 10, y: 10)] as UIBezierPath

"(\w+)" as Regex
"0.1.0" as Version

[
    "user": [
        "name": "Patrick Perini",
        "id": "0000"
    ] as JSONDictionary
] as JSONDictionary
```

### Classes

```swift
struct Regex {
    error: NSError?
    doesMatch(string: String) -> Bool
    hasMatch(string: String) -> Bool
    matchedCaptureGroups(string: String) -> [[String]]
}
```

```swift
class IdentifiableObject: Hashable {
    identifier: String
}
```

```swift
struct Distribution: CollectionType, Sliceable {
    sum: Double
    mean: Double
    mode: Double
    median: Double
    max: Double
    histogram() -> String
}
```

* * *

## Contact

### Creator

- [Patrick Perini](http://github.com/pcperini) ([@pcperini](https://twitter.com/pcperini))

## License

Thrust is released under the MIT license. See LICENSE for details.

### Special Thanks to

Mattt Thompson, for the README structure. Zachary Waldowski and Alexsander Akers for feedback.