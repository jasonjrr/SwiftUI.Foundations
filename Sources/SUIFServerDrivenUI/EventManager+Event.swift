//
//  EventManager+Event.swift
//
//
//  Created by Jason Lew-Rapai on 4/23/24.
//

import Foundation

extension SDUI.EventManager {
    public struct Event {
        public let identifier: String
        public let value: EventValue?
        
        public init(identifier: String, value: EventValue? = nil) {
            self.identifier = identifier
            self.value = value
        }
    }
    
    public enum EventValue {
        case string(String)
        case int(Int)
        case double(Double)
        case bool(Bool)
        
        case error(Error)
    }
}
