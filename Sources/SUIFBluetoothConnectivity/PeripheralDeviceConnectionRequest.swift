//
//  PeripheralDeviceConnectionRequest.swift
//  
//
//  Created by Jason Lew-Rapai on 8/27/24.
//

import Foundation

extension Bluetooth {
    public struct PeripheralDeviceConnectionRequest: Identifiable, Equatable {
        public enum State: Equatable {
            case connecting
            case connected
            case error(any Error)
            
            public static func == (lhs: PeripheralDeviceConnectionRequest.State, rhs: PeripheralDeviceConnectionRequest.State) -> Bool {
                switch (lhs, rhs) {
                case (.connecting, .connecting):
                    return true
                case (.connected, .connected):
                    return true
                case (.error, .error):
                    return true
                default:
                    return false
                }
            }
        }
        
        public let device: PeripheralDevice
        public internal(set) var state: State = .connecting
        
        public var id: UUID { self.device.id }
        
        public static func == (lhs: PeripheralDeviceConnectionRequest, rhs: PeripheralDeviceConnectionRequest) -> Bool {
            lhs.id == rhs.id
            && lhs.state == rhs.state
            && lhs.device == rhs.device
        }
    }
}
