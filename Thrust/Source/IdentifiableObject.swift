//
//  Identifiable.swift
//  Thrust
//
//  Created by Patrick Perini on 9/3/14.
//  Copyright (c) 2014 pcperini. All rights reserved.
//

import Foundation

func ==(lhs: IdentifiableObject, rhs: IdentifiableObject) -> Bool {
    return lhs.identifier == rhs.identifier
}

class IdentifiableObject: Hashable {
    // MARK: - Properties
    private var uuid: String
    
    var identifier: String {
        return self.uuid
    }
    
    var hashValue: Int {
        return self.uuid.hashValue
    }
    
    // MARK: - Initializers
    convenience init() {
        self.init(NSUUID().UUIDString)
    }
    
    required init(_ uuid: String) {
        self.uuid = uuid
    }
}