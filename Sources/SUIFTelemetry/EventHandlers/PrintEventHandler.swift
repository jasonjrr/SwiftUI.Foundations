//
//  PrintEventHandler.swift
//  
//
//  Created by Jason Lew-Rapai on 4/13/24.
//

import Foundation
import SwiftUIFoundation

extension Telemetry {
    public struct PrintEventHandler: Telemetry.EventHandling {
        public func log(_ event: some Telemetry.Event) {
            if let performanceTraceEvent = event as? Telemetry.PerformanceTraceEvent {
                let duration: String
                if let endDate = performanceTraceEvent.endDate {
                    duration = "\(String(format: "%.4f", endDate.timeIntervalSince(performanceTraceEvent.startDate)))s"
                } else {
                    duration = "Event did not complete"
                }
                print("""
                
                ⏱️ Performance.Trace: \(duration)
                \(performanceTraceEvent)
                
                """)
            } else if let codableEvent = event as? Codable {
                print("\n🪵 Telemetry.Log:\n\(codableEvent.prettyPrintJSON())\n")
            } else {
                print("\n🪵 Telemetry.Log: \(event)\n")
            }
        }
    }
}
