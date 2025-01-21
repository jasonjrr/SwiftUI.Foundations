//
//  Publisher+TrackPerformanceTraceCompletion.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/15/25.
//

import Foundation
import Combine

extension Publisher {
    public func trackPerformanceTraceCompletion(_ performanceTraceSubject: Telemetry.PerformanceTraceSubject, data: [String: Any] = [:], metadata: Telemetry.CallerMetadata) -> Publishers.HandleEvents<Self> {
        return self.handleEvents(receiveCompletion: { completion in
            var traceError: Error?
            switch completion {
            case .finished: break
            case .failure(let error):
                traceError = error
            }
            performanceTraceSubject.end(data: data, metadata: metadata, error: traceError)
        })
    }
}
