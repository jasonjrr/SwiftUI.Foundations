//
//  HapticPatternPlayerSubject.swift
//
//
//  Created by Jason Lew-Rapai on 8/30/24.
//

import Foundation
import CoreHaptics
import SwiftUIFoundation
import SUIFTelemetry

///
/// Represents a subject for managing haptic playback.
///
public class HapticPatternPlayerSubject: Identifiable {
    private let telemetry: Telemetry.TelemetryServiceProtocol
    
    /// The unique identifier for the `HapticPatternPlayerSubject`.
    public let id: SwiftUIFoundation.ID<HapticPatternPlayerSubject> = SwiftUIFoundation.ID()
    
    private weak var delegate: HapticPatternPlayerSubject.Delegate?
    
    private let player: CHHapticPatternPlayer
    
    /// Initializes a `HapticPatternPlayerSubject` with the specified telemetry service, haptic pattern player, and delegate.
    ///
    /// - Parameters:
    ///   - telemetry: The telemetry service protocol.
    ///   - player: The ``CHHapticPatternPlayer`` for haptic playback.
    ///   - delegate: The delegate for handling haptic pattern player events.
    init(telemetry: Telemetry.TelemetryServiceProtocol, player: CHHapticPatternPlayer, delegate: HapticPatternPlayerSubject.Delegate) {
        self.telemetry = telemetry
        self.player = player
        self.delegate = delegate
    }
    
    /// Stops the haptic pattern playback at the specified time.
    ///
    /// - Parameters:
    ///   - time: The relative time at which to stop the haptic pattern playback (default is ``CHHapticTimeImmediate``).
    public func stop(atTime time: TimeInterval = CHHapticTimeImmediate) {
        do {
            try self.player.stop(atTime: time)
            self.delegate?.hapticPatternPlayerSubject(self, didStopAtTime: time)
        } catch let error {
            self.telemetry.log(TelemetryEvent.failedToStopHapticPlayer(error))
            self.delegate?.hapticPatternPlayerSubject(self, failedToStopWith: error)
        }
    }
}

// MARK: Delegate
extension HapticPatternPlayerSubject {
    protocol Delegate: AnyObject {
        func hapticPatternPlayerSubject(_ source: HapticPatternPlayerSubject, didStopAtTime time: TimeInterval)
        func hapticPatternPlayerSubject(_ source: HapticPatternPlayerSubject, failedToStopWith error: any Error)
    }
}

// MARK: TelemetryEvent
extension HapticPatternPlayerSubject {
    enum TelemetryEvent: Telemetry.Event {
        case failedToStopHapticPlayer(any Error)
    }
}
