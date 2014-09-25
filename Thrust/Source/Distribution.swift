//
//  Distribution.swift
//  Thrust
//
//  Created by Patrick Perini on 9/23/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

struct Distribution: CollectionType, Sliceable {
    // MARK: Types
    typealias SubSlice = Slice<Double>
    typealias Index = Int
    
    // MARK: Properties
    private var data: [Double: Int] = [:]
    private var dataSet: [Double] {
        get {
            var dataSet: [Double] = []
            for (dataKey, dataCount) in self.data {
                dataSet.pad(dataKey, toLength: dataSet.count + dataCount)
            }
            
            dataSet.sort({ $0 > $1 })
            return dataSet
        }
    }
    
    var startIndex: Index {
        return self.dataSet.startIndex
    }
    
    var endIndex: Index {
        return self.dataSet.endIndex
    }
    
    subscript (index: Index) -> Double {
        return self.dataSet[index]
    }
    
    subscript (subRange: Range<Index>) -> SubSlice {
        return self.dataSet[subRange]
    }
    
    var count: Index {
        return self.dataSet.count
    }
    
    /// The sum of all values in the distribution.
    var sum: Double {
        get {
            var sum: Double = 0
            for dataValue in self.dataSet {
                sum += dataValue
            }
            
            return sum
        }
    }
    
    /// The average value in the distribution.
    var mean: Double {
        get {
            return self.sum / Double(self.count)
        }
    }
    
    /// The most frequently occuring value in the distribution.
    var mode: Double {
        get {
            var maxDataCount = Int.min
            var maxDataKey: Double = -Double.infinity
            
            for (dataKey, dataCount) in self.data {
                if dataCount > maxDataCount {
                    maxDataCount = dataCount
                    maxDataKey = dataKey
                }
            }
            
            return maxDataKey
        }
    }
    
    /// The middle value in the distribution.
    var median: Double {
        get {
            var dataSet = self.dataSet
            var medianIndex = dataSet.count / 2
            return (medianIndex < dataSet.count) ? dataSet[medianIndex] : Double.NaN
        }
    }
    
    /// The highest value in the distribution.
    var max: Double {
        get {
            return comp(self.dataSet, { $0 > $1 }) ?? -Double.infinity
        }
    }
    
    /// The lowest value in the distribution.
    var min: Double {
        get {
            return comp(self.dataSet, { $0 < $1 }) ?? Double.infinity
        }
    }
    
    // MARK: Initializers
    init(dataSet: [Double]) {
        for dataKey in dataSet {
            if let dataCount = self.data[dataKey] {
                self.data[dataKey] = dataCount + 1
            } else {
                self.data[dataKey] = 1
            }
        }
    }
    
    // MARK: Accessors
    func generate() -> IndexingGenerator<[Double]> {
        return self.dataSet.generate()
    }
    
    /// A histrogram representation of the data.
    func histogram() -> String {
        var rows: [String] = []
        var maxHeight: Int = self.data[self.mode]!
        var sortedKeys = self.data.keys.array.sorted(<)
        
        for rowIndex in reverse(0 ..< maxHeight) {
            for dataKey in sortedKeys {
                var dataCount = self.data[dataKey]
                
                var row = ""
                if dataCount > rowIndex {
                    row += "•  "
                } else {
                    row += "   "
                }
                
                rows.append(row)
            }
            
            rows.append("\n")
        }
        
        rows.append(("---" * sortedKeys.count) + "\n")
        rows.append(" ".join(sortedKeys.map({ $0 >= 10 ? "\(Int($0))" : "0\(Int($0))" })))
        return "\n" + "".join(rows) + "\n"
    }
}