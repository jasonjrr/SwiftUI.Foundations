//
//  HapticFeedbackGenerator.swift
//
//
//  Created by Jason Lew-Rapai on 8/30/24.
//

import Foundation
import CoreHaptics
import SUIFTelemetry

///
/// A protocol for providing haptic feedback generation capabilities.
///
public protocol HapticFeedbackGeneratorProtocol {
    /// Indicates whether the device supports haptic feedback.
    var deviceSupportsHaptics: Bool { get }
    
    /// Starts haptic feedback generation with the specified events.
    ///
    /// - Parameter events: An array of ``CHHapticEvent`` objects representing the haptic feedback events.
    /// - Returns: A `HapticPatternPlayerSubject` instance to manage the haptic playback.
    func start(with events: [CHHapticEvent]) -> HapticPatternPlayerSubject
}

public class HapticFeedbackGenerator {
    private let engine: CHHapticEngine?
    private let telemetry: Telemetry.TelemetryServiceProtocol
    
    @inlinable
    public var deviceSupportsHaptics: Bool {
        CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }
    
    public init(telemetry: Telemetry.TelemetryServiceProtocol) {
        self.telemetry = telemetry
        do {
            self.engine = try CHHapticEngine()
        } catch let error {
            self.engine = nil
            telemetry.log(TelemetryEvent.couldNotCreateHapticEngine(error))
        }
    }
    
    public func start(with events: [CHHapticEvent]) -> HapticPatternPlayerSubject? {
        guard let engine else {
            return nil
        }
        guard self.deviceSupportsHaptics else {
            self.telemetry.log(TelemetryEvent.hapticsNotSupportedOnThisDevice)
            return nil
        }
        do {
            try engine.start()
            let pattern = try CHHapticPattern(
                events: events,
                parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: CHHapticTimeImmediate)
            self.telemetry.log(TelemetryEvent.hapticEngineStarted(atTime: CHHapticTimeImmediate))
            return HapticPatternPlayerSubject(telemetry: self.telemetry, player: player, delegate: self)
        } catch let error {
            self.telemetry.log(TelemetryEvent.failedToStartHapticEngine(error))
            return nil
        }
    }
    
    private func stop(atTime time: TimeInterval = CHHapticTimeImmediate) {
        self.telemetry.log(TelemetryEvent.hapticEngineStopped(atTime: time))
    }
}

// MARK: HapticPatternPlayerSubject.Delegate
extension HapticFeedbackGenerator: HapticPatternPlayerSubject.Delegate {
    func hapticPatternPlayerSubject(_ source: HapticPatternPlayerSubject, didStopAtTime time: TimeInterval) {
        stop(atTime: time)
    }
    
    func hapticPatternPlayerSubject(_ source: HapticPatternPlayerSubject, failedToStopWith error: any Error) {
        stop()
    }
}

// MARK: TelemetryEvents
extension HapticFeedbackGenerator {
    enum TelemetryEvent: Telemetry.Event {
        case couldNotCreateHapticEngine(any Error)
        case failedToStartHapticEngine(any Error)
        case hapticEngineStarted(atTime: TimeInterval)
        case hapticEngineStopped(atTime: TimeInterval)
        case hapticsNotSupportedOnThisDevice
    }
}
