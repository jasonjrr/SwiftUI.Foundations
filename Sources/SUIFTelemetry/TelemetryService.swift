//
//  TelemetryService.swift
//
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Telemetry {
    /// Service protocol that specifies the required functionality for telemetry logging
    public protocol TelemetryServiceProtocol: AnyObject {
        /// Registers the specifies `eventHandler` to the service
        ///
        /// - Parameters:
        ///   - eventHandler: An instance of `EventHandling` that will attempt to log `Event`s
        func register(_ eventHandler: any Telemetry.EventHandling)
        func register(_ eventHandlers: [any Telemetry.EventHandling])
        func register(_ eventHandlers: any Telemetry.EventHandling...)
        
        func log(_ event: some Telemetry.Event)
        func logPerformanceTrace(_ eventName: String, data: [String: Any], startMetadata: Telemetry.CallerMetadata, startDate: Date, endMetadata: Telemetry.CallerMetadata, endDate: Date?)
        func startPerformanceTrace(_ eventName: String, metadata startMetadata: Telemetry.CallerMetadata, startDate: Date) -> Telemetry.PerformanceTraceSubject
    }
}

extension Telemetry.TelemetryServiceProtocol {
    func startPerformanceTrace(_ eventName: String, metadata startMetadata: Telemetry.CallerMetadata = .metadata(), startDate: Date = Date()) -> Telemetry.PerformanceTraceSubject {
        startPerformanceTrace(eventName, metadata: startMetadata, startDate: startDate)
    }
}

extension Telemetry {
    public class TelemetryService: Telemetry.TelemetryServiceProtocol {
        private var eventHandlers: [any Telemetry.EventHandling] = []
        
        public func register(_ eventHandler: any Telemetry.EventHandling) {
            self.eventHandlers.append(eventHandler)
        }
        
        public func register(_ eventHandlers: [any Telemetry.EventHandling]) {
            self.eventHandlers.append(contentsOf: eventHandlers)
        }
        
        public func register(_ eventHandlers: any Telemetry.EventHandling...) {
            self.eventHandlers.append(contentsOf: eventHandlers)
        }
        
        public func log(_ event: some Telemetry.Event) {
            Task {
                await withTaskGroup(of: Void.self) { group in
                    self.eventHandlers.forEach { handler in
                        group.addTask {
                            await handler.log(event)
                        }
                    }
                }
            }
        }
        
        public func logPerformanceTrace(_ eventName: String, data: [String : Any], startMetadata: Telemetry.CallerMetadata, startDate: Date, endMetadata: Telemetry.CallerMetadata, endDate: Date?) {
            let event = Telemetry.PerformanceTraceEvent(
                eventName: eventName,
                data: data,
                startMetadata: startMetadata,
                startDate: startDate,
                endMetadata: endMetadata,
                endDate: endDate)
            log(event)
        }
        
        public func startPerformanceTrace(
            _ eventName: String,
            metadata startMetadata: Telemetry.CallerMetadata = .metadata(),
            startDate: Date = Date()
        ) -> Telemetry.PerformanceTraceSubject {
            Telemetry.PerformanceTraceSubject(
                eventName: eventName,
                startMetadata: startMetadata,
                startDate: startDate,
                delegate: self)
        }
    }
}

extension Telemetry.TelemetryService: Telemetry.PerformanceTraceSubject.Delegate {
    public func telemetryPerformanceTraceSubject(_ source: Telemetry.PerformanceTraceSubject, didEndWithData data: [String : Any], endMetadata: Telemetry.CallerMetadata, endDate: Date?) {
        logPerformanceTrace(
            source.eventName,
            data: data,
            startMetadata: source.startMetadata,
            startDate: source.startDate,
            endMetadata: endMetadata,
            endDate: endDate)
    }
}
