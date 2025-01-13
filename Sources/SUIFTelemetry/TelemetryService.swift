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
        func onAppLaunch(withOptions launchOptions: [AppLaunchOptionsKey: Any]?)
        
        func identifyUser(with properties: [String: Any]?)
        
        func log(_ event: some Telemetry.Event)
        func logPerformanceTrace(_ eventName: String, phase: Telemetry.PerformanceTraceEvent.Phase, traceID: Telemetry.EventTraceID?, data: [String: Any], startMetadata: Telemetry.CallerMetadata, startDate: Date, endMetadata: Telemetry.CallerMetadata, endDate: Date?)
        func logPerformanceTrace(_ eventName: String, phase: Telemetry.PerformanceTraceEvent.Phase, traceID: Telemetry.EventTraceID?, data: [String: Any], startMetadata: Telemetry.CallerMetadata, startDate: Date, endMetadata: Telemetry.CallerMetadata, error: Error?, endDate: Date?)
        func startPerformanceTrace(_ eventName: String, phase: Telemetry.PerformanceTraceEvent.Phase, traceID: Telemetry.EventTraceID?, metadata startMetadata: Telemetry.CallerMetadata, startDate: Date) -> Telemetry.PerformanceTraceSubject
    }
}

extension Telemetry.TelemetryServiceProtocol {
    public func startPerformanceTrace(_ eventName: String, phase: Telemetry.PerformanceTraceEvent.Phase, traceID: Telemetry.EventTraceID? = nil, metadata startMetadata: Telemetry.CallerMetadata, startDate: Date = Date()) -> Telemetry.PerformanceTraceSubject {
        startPerformanceTrace(eventName, phase: phase, traceID: traceID, metadata: startMetadata, startDate: startDate)
    }
}

extension Telemetry {
    public class TelemetryService: Telemetry.TelemetryServiceProtocol {
        private var eventHandlers: [any Telemetry.EventHandling] = []
        
        public init(eventHandlers: (any Telemetry.EventHandling)...) {
            self.eventHandlers = eventHandlers
        }
        
        public func onAppLaunch(withOptions launchOptions: [AppLaunchOptionsKey: Any]?) {
            Task {
                await withTaskGroup(of: Void.self) { group in
                    self.eventHandlers.forEach { handler in
                        group.addTask {
                            await handler.onAppLaunch(withOptions: launchOptions)
                        }
                    }
                }
            }
        }
        
        public func identifyUser(with properties: [String: Any]?) {
            Task {
                await withTaskGroup(of: Void.self) { group in
                    self.eventHandlers.forEach { handler in
                        group.addTask {
                            await handler.identifyUser(with: properties)
                        }
                    }
                }
            }
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
        
        public func logPerformanceTrace(
            _ eventName: String,
            phase: Telemetry.PerformanceTraceEvent.Phase,
            traceID: Telemetry.EventTraceID? = nil,
            data: [String : Any],
            startMetadata: Telemetry.CallerMetadata,
            startDate: Date,
            endMetadata: Telemetry.CallerMetadata,
            endDate: Date?
        ) {
            logPerformanceTrace(
                eventName,
                phase: phase,
                traceID: traceID,
                data: data,
                startMetadata: startMetadata,
                startDate: startDate,
                endMetadata: endMetadata,
                error: nil,
                endDate: endDate
            )
        }
        
        public func logPerformanceTrace(
            _ eventName: String,
            phase: Telemetry.PerformanceTraceEvent.Phase,
            traceID: Telemetry.EventTraceID? = nil,
            data: [String : Any],
            startMetadata: Telemetry.CallerMetadata,
            startDate: Date,
            endMetadata: Telemetry.CallerMetadata,
            error: Error?,
            endDate: Date?
        ) {
            let event = Telemetry.PerformanceTraceEvent(
                eventName: eventName,
                phase: phase,
                traceID: traceID,
                data: data,
                startMetadata: startMetadata,
                startDate: startDate,
                endMetadata: endMetadata,
                error: error,
                endDate: endDate)
            log(event)
        }
        
        public func startPerformanceTrace(
            _ eventName: String,
            phase: Telemetry.PerformanceTraceEvent.Phase,
            traceID: Telemetry.EventTraceID? = nil,
            metadata startMetadata: Telemetry.CallerMetadata,
            startDate: Date = Date()
        ) -> Telemetry.PerformanceTraceSubject {
            Telemetry.PerformanceTraceSubject(
                eventName: eventName,
                phase: phase,
                traceID: traceID,
                startMetadata: startMetadata,
                startDate: startDate,
                delegate: self)
        }
    }
}

extension Telemetry.TelemetryService: Telemetry.PerformanceTraceSubject.Delegate {
    public func telemetryPerformanceTraceSubject(
        _ source: Telemetry.PerformanceTraceSubject,
        didEndWithEvent eventName: String,
        phase: Telemetry.PerformanceTraceEvent.Phase,
        traceID: Telemetry.EventTraceID?,
        data: [String : Any],
        endMetadata: Telemetry.CallerMetadata,
        error: (any Error)?,
        endDate: Date?
    ) {
        logPerformanceTrace(
            eventName,
            phase: phase,
            data: data,
            startMetadata: source.startMetadata,
            startDate: source.startDate,
            endMetadata: endMetadata,
            error: error,
            endDate: endDate)
    }
}
