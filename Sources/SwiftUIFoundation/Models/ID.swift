//
//  ID.swift
//
//
//  Created by Jason Lew-Rapai on 8/30/24.
//

import Foundation

public struct ID<Owner>: Codable, Equatable, Hashable, Sendable {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
    
    public init() {
        self.value = UUID().uuidString
    }
}
