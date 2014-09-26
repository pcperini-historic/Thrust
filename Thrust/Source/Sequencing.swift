//
//  Sequencing.swift
//  Thrust
//
//  Created by Patrick Perini on 9/24/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

// MARK: - Functions
/// Returns the index of the given object.
func index<S: SequenceType where S.Generator.Element: Equatable>(seq: S, obj: S.Generator.Element) -> Int? {
    for (index, anObject) in enumerate(seq) {
        if (anObject as S.Generator.Element) == (obj as S.Generator.Element) {
            return index
        }
    }
    
    return nil
}

/// Returns the most `comp` value in the sequence.
func comp<S: SequenceType, L: BooleanType>(seq: S, comp: (S.Generator.Element, S.Generator.Element) -> L) -> S.Generator.Element? {
    var compVal: S.Generator.Element? = nil
    for obj in seq {
        compVal = (compVal == nil) ? obj : ((comp(obj, compVal!)) ? obj : compVal)
    }
    
    return compVal
}

/// Returns the max value in the sequence.
func max<S: SequenceType where S.Generator.Element: Comparable>(seq: S) -> S.Generator.Element? {
    return comp(seq, { $0 > $1 })
}

/// Returns the min value in the sequence.
func min<S: SequenceType where S.Generator.Element: Comparable>(seq: S) -> S.Generator.Element? {
    return comp(seq, { $0 < $1 })
}