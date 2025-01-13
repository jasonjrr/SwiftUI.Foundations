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
        public init() {}
        
        private func logORErrorEmoji(_ event: Event) -> String {
            if let _ = event as? ErrorEvent {
                return "‼️"
            } else {
                return "🪵"
            }
        }
        
        public func onAppLaunch(withOptions launchOptions: [AppLaunchOptionsKey: Any]?) async {}
        
        public func identifyUser(with properties: [String: Any]?) async {
            if let properties = properties {
                print("\n👤 Telemetry.User:\n\(properties)\n")
            } else {
                print("\n👤 Telemetry.User:\nProperties REMOVED")
            }
        }
        
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
                print("\n\(logORErrorEmoji(event)) Telemetry.Log:\n\(codableEvent.prettyPrintJSON())\n")
            } else {
                print("\n\(logORErrorEmoji(event)) Telemetry.Log: \(event)\n")
            }
        }
    }
}
