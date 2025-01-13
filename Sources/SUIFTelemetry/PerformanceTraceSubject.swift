//
//  PerformanceTraceSubject.swift
//
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Telemetry {
    public class PerformanceTraceSubject {
        public let eventName: String
        public let phase: Telemetry.PerformanceTraceEvent.Phase
        public let traceID: EventTraceID?
        let startMetadata: Telemetry.CallerMetadata
        let startDate: Date
        
        private weak var delegate: Telemetry.PerformanceTraceSubject.Delegate?
        
        private var handled: Bool = false
        
        init(eventName: String, phase: Telemetry.PerformanceTraceEvent.Phase, traceID: EventTraceID?, startMetadata: Telemetry.CallerMetadata, startDate: Date, delegate: Telemetry.PerformanceTraceSubject.Delegate) {
            self.eventName = eventName
            self.phase = phase
            self.traceID = traceID
            self.delegate = delegate
            self.startMetadata = startMetadata
            self.startDate = startDate
        }
        
        deinit {
            end(metadata: .metadata(), endDate: nil)
        }
        
        public func end(data: [String: Any] = [:], metadata: Telemetry.CallerMetadata, error: Error? = nil, endDate: Date? = Date()) {
            if self.handled { return }
            self.handled = true
            self.delegate?.telemetryPerformanceTraceSubject(self, didEndWithEvent: eventName, phase: phase, traceID: self.traceID, data: data, endMetadata: metadata, error: error, endDate: endDate)
        }
    }
}

extension Telemetry.PerformanceTraceSubject {
    public protocol Delegate: AnyObject {
        func telemetryPerformanceTraceSubject(_ source: Telemetry.PerformanceTraceSubject, didEndWithEvent eventName: String, phase: Telemetry.PerformanceTraceEvent.Phase, traceID: Telemetry.EventTraceID?, data: [String: Any], endMetadata: Telemetry.CallerMetadata, error: Error?, endDate: Date?)
    }
}
