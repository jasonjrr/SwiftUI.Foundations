//
//  PerformanceTraceEvent.swift
//
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Telemetry {
    public struct PerformanceTraceEvent: Event, CustomStringConvertible {
        public let eventName: String
        public let phase: Telemetry.PerformanceTraceEvent.Phase
        public let traceID: Telemetry.EventTraceID?
        public let data: [String: Sendable]
        public let startMetadata: Telemetry.CallerMetadata
        public let startDate: Date
        public let endMetadata: Telemetry.CallerMetadata
        public let error: Error?
        public let endDate: Date?
        
        public var duration: TimeInterval? {
            guard let endDate else { return nil }
            return endDate.timeIntervalSince(self.startDate)
        }
        
        public var description: String {
            return """
                PerformanceTraceEvent (\(self.endDate != nil ? "\(self.duration!)" : "N/A")s)
                    eventName: \(self.eventName)
                    phase: \(self.phase.rawValue)
                    traceID: \(self.traceID != nil ? self.traceID!.value : "N/A")
                    data: \(self.data)
                    startMetadata: \(self.startMetadata)
                    startDate: \(self.startDate)
                    endMetadata: \(self.endMetadata)
                    error: \(String(describing: self.error))
                    endDate: \(self.endDate != nil ? String(describing: self.endDate!) : "N/A"))
            """
        }
        
        init(
            eventName: String,
            phase: Telemetry.PerformanceTraceEvent.Phase,
            traceID: Telemetry.EventTraceID?,
            data: [String : Any],
            startMetadata: Telemetry.CallerMetadata,
            startDate: Date,
            endMetadata: Telemetry.CallerMetadata,
            error: Error?,
            endDate: Date?
        ) {
            self.eventName = eventName
            self.phase = phase
            self.traceID = traceID
            self.data = data
            self.startMetadata = startMetadata
            self.startDate = startDate
            self.endMetadata = endMetadata
            self.error = error
            self.endDate = endDate
        }
    }
}

extension Telemetry.PerformanceTraceEvent {
    public enum Phase: String, Sendable {
        case deserialization = "deserialization"
        case endToEnd = "end_to_end"
        case networkRoundTrip = "network_round_trip"
        case serialization = "serialization"
    }
}
