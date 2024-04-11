//
//  PerformanceTraceEvent.swift
//
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Telemetry {
    public struct PerformanceTraceEvent: Event {
        public let eventName: String
        public let data: [String: Any]
        public let startMetadata: Telemetry.CallerMetadata
        public let startDate: Date
        public let endMetadata: Telemetry.CallerMetadata
        public let endDate: Date?
        
        init(eventName: String, data: [String : Any], startMetadata: Telemetry.CallerMetadata, startDate: Date, endMetadata: Telemetry.CallerMetadata, endDate: Date?) {
            self.eventName = eventName
            self.data = data
            self.startMetadata = startMetadata
            self.startDate = startDate
            self.endMetadata = endMetadata
            self.endDate = endDate
        }
    }
}
