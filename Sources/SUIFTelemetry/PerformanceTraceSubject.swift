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
        let startMetadata: Telemetry.CallerMetadata
        let startDate: Date
        
        private weak var delegate: Telemetry.PerformanceTraceSubject.Delegate?
        
        private var handled: Bool = false
        
        init(eventName: String, startMetadata: Telemetry.CallerMetadata, startDate: Date, delegate: Telemetry.PerformanceTraceSubject.Delegate) {
            self.eventName = eventName
            self.delegate = delegate
            self.startMetadata = startMetadata
            self.startDate = startDate
        }
        
        deinit {
            end(endDate: nil)
        }
        
        func end(data: [String: Any] = [:], metadata: Telemetry.CallerMetadata = .metadata(), endDate: Date? = Date()) {
            if self.handled { return }
            self.handled = true
            self.delegate?.telemetryPerformanceTraceSubject(self, didEndWithData: data, endMetadata: metadata, endDate: endDate)
        }
    }
}

extension Telemetry.PerformanceTraceSubject {
    public protocol Delegate: AnyObject {
        func telemetryPerformanceTraceSubject(_ source: Telemetry.PerformanceTraceSubject, didEndWithData data: [String: Any], endMetadata: Telemetry.CallerMetadata, endDate: Date?)
    }
}
