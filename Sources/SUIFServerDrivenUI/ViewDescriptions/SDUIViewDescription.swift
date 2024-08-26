//
//  SDUIViewDescription.swift
//
//
//  Created by Jason Lew-Rapai on 4/22/24.
//

import SwiftUI

extension SDUI {
    public struct ViewDescription: Identifiable, Codable {
        public var id: UUID
        public let factoryName: String
        public let identifier: String
        public let properties: [String: String]
        public let children: [ViewDescription]
        
        public init(factoryName: String, identifier: String, properties: [String: String] = [:], children: [ViewDescription] = []) {
            self.id = UUID()
            self.factoryName = factoryName
            self.identifier = identifier
            self.properties = properties
            self.children = children
        }
    }
}
