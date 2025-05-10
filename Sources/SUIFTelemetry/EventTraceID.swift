//
//  File.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/12/25.
//

import Foundation

import Foundation

extension Telemetry {
    public struct EventTraceID: Codable, CustomStringConvertible, Sendable {
        public let value: String
        
        public var description: String {
            return self.value
        }
        
        public init(value: String = UUID().uuidString) {
            self.value = value
        }
        
        public static func traceID() -> EventTraceID {
            EventTraceID()
        }
    }
}
