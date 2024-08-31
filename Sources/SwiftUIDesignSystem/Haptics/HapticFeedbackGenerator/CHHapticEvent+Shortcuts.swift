//
//  CHHapticEvent+Shortcuts.swift
//
//
//  Created by Jason Lew-Rapai on 8/30/24.
//

import Foundation
import CoreHaptics

///
/// Extension on CHHapticEvent providing static methods to reduce API 
/// footprints when creating haptic events.
///
extension CHHapticEvent {
    /// Creates a continuous haptic event with the specified parameters.
    ///
    /// - Parameters:
    ///   - relativeTime: The relative time at which the event occurs.
    ///   - duration: The duration of the haptic event.
    ///   - intensity: The intensity of the haptic event (optional).
    ///   - sharpness: The sharpness of the haptic event (optional).
    /// - Returns: A ``CHHapticEvent`` representing the continuous haptic event.
    public static func continuous(relativeTime: TimeInterval, duration: TimeInterval, intensity: Float? = nil, sharpness: Float? = nil) -> CHHapticEvent {
        var params: [CHHapticEventParameter] = []
        if let intensity {
            params.append(CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity))
        }
        if let sharpness {
            params.append(CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness))
        }
        
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: params,
            relativeTime: relativeTime,
            duration: duration)
        return event
    }
    
    /// Creates a transient haptic event with the specified parameters.
    ///
    /// - Parameters:
    ///   - relativeTime: The relative time at which the event occurs.
    ///   - duration: The duration of the haptic event.
    ///   - intensity: The intensity of the haptic event (optional).
    ///   - sharpness: The sharpness of the haptic event (optional).
    /// - Returns: A ``CHHapticEvent`` representing the transient haptic event.
    public static func transient(relativeTime: TimeInterval, duration: TimeInterval, intensity: Float? = nil, sharpness: Float? = nil) -> CHHapticEvent {
        var params: [CHHapticEventParameter] = []
        if let intensity {
            params.append(CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity))
        }
        if let sharpness {
            params.append(CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness))
        }
        
        let event = CHHapticEvent(
            eventType: .hapticTransient,
            parameters: params,
            relativeTime: relativeTime,
            duration: duration)
        return event
    }
}
