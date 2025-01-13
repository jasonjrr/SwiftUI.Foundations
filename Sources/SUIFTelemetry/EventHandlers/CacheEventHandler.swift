//
//  CacheEventHandler.swift
//
//
//  Created by Jason Lew-Rapai on 4/13/24.
//

import Foundation
import Combine
import SwiftUIFoundation

extension Telemetry {
    /// Telemetry event handler that caches events.
    public actor CacheEventHandler: Telemetry.EventHandling {
        nonisolated private let _events: CurrentValueSubject<[any Telemetry.Event], Never> = CurrentValueSubject([])
        public var events: AnyPublisher<[any Telemetry.Event], Never> { self._events.eraseToAnyPublisher() }
        
        private let maximumCacheSize: Int?
        
        public init(maximumCacheSize: Int? = nil) {
            self.maximumCacheSize = maximumCacheSize
        }
        
        public func onAppLaunch(withOptions launchOptions: [AppLaunchOptionsKey: Any]?) async {}
        
        public func identifyUser(with properties: [String: Any]?) async {}
        
        public func log(_ event: some Telemetry.Event) async {
            let maximumCacheSize = self.maximumCacheSize
            let _ = try? await self._events
                .justLatest()
                .map { [weak self] events in
                    guard let self else { return }
                    var events = events
                    events.insert(event, at: 0)
                    if let maximumCacheSize, events.count > maximumCacheSize {
                        events = Array(events.prefix(maximumCacheSize))
                    }
                    self._events.send(events)
                }
                .eraseToAnyPublisher()
                .async()
        }
    }
}
