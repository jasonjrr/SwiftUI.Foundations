//
//  EventCoordinator.swift
//
//
//  Created by Jason Lew-Rapai on 4/22/24.
//

import Foundation
import Combine
import SwiftUI

extension SDUI {
    public class EventCoordinator: ObservableObject {
        private let eventBus: PassthroughSubject<Event, Never> = PassthroughSubject()
        public var events: AnyPublisher<Event, Never> {
            self.eventBus.eraseToAnyPublisher()
        }
        
        private let valueCache: CurrentValueSubject<[String: EventValue], Never> = CurrentValueSubject([:])
        private let valueBus: PassthroughSubject<Event, Never> = PassthroughSubject()
        
        private var cancellables: Set<AnyCancellable> = []
        
        public init() {
            self.valueBus
                .receive(on: DispatchSerialQueue.global(qos: .userInitiated))
                .withLatestFrom(self.valueCache) {($0, $1) }
                .sink(receiveValue: { [valueCache] event, values in
                    var values = values
                    values[event.identifier] = event.value
                    valueCache.send(values)
                })
                .store(in: &self.cancellables)
        }
        
        public func publishEvent(_ event: Event) {
            self.eventBus.send(event)
        }
        
        public func publishEvent(withIdentifier identifier: String, value: EventValue? = nil) {
            publishEvent(Event(identifier: identifier, value: value))
        }
        
        public func value(for valueIdentifier: String) -> AnyPublisher<EventValue?, Never> {
            self.valueCache.map { cache in
                cache[valueIdentifier]
            }
            .eraseToAnyPublisher()
        }
        
        public func publishValue(withIdentifier identifier: String, value: EventValue) {
            self.valueBus.send(Event(identifier: identifier, value: value))
        }
        
        public func clearValues() {
            self.valueCache.send([:])
        }
    }
}

extension SDUI {
    /// `EnvironmentKey` used to store the `EventCoordinator` in the SwiftUI environment.
    public struct EventCoordinatorEnvironmentKey: EnvironmentKey {
        public static var defaultValue: SDUI.EventCoordinator = SDUI.EventCoordinator()
    }
}

extension EnvironmentValues {
    public var eventCoordinator: SDUI.EventCoordinator {
        get { self[SDUI.EventCoordinatorEnvironmentKey.self] }
        set { self[SDUI.EventCoordinatorEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// Sets the environment value `EventCoordinator` to the given value.
    ///
    /// Use this modifier to set the ``EnvironmentValues/eventCoordinator`` 
    /// key in the ``EnvironmentValues`` structure.
    ///
    ///     MyView()
    ///         .eventCoordinator(coordinator)
    ///
    /// You then read the value inside `MyView` or one of its descendants
    /// using the ``Environment`` property wrapper:
    ///
    ///     struct MyView: View {
    ///         @Environment(\.eventCoordinator) var eventCoordinator: SDUI.EventCoordinator
    ///
    ///         var body: some View { ... }
    ///     }
    ///
    /// This modifier affects the given view,
    /// as well as that view's descendant views. It has no effect
    /// outside the view hierarchy on which you call it.
    ///
    /// - Parameters:
    ///   - coordinator: The `SDUI.EventCoordinator` to be
    ///     stored in the``EnvironmentValues`` structure.
    ///
    /// - Returns: A view that has the given value set in its environment.
    public func eventCoordinator(_ coordinator: SDUI.EventCoordinator) -> some View {
        environment(\.eventCoordinator, coordinator)
    }
}
