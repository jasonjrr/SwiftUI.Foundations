//
//  PeripheralDevice.swift
//  
//
//  Created by Jason Lew-Rapai on 8/27/24.
//

import Foundation
import CoreBluetooth

extension Bluetooth {
    public struct PeripheralDevice: Identifiable, Equatable {
        public let peripheral: CBPeripheral
        public let advertisementData: [String : Any]
        public let rssi: Int
        
        public var id: UUID { self.peripheral.identifier }
        
        public static func == (lhs: PeripheralDevice, rhs: PeripheralDevice) -> Bool {
            lhs.id == rhs.id
            && lhs.peripheral == rhs.peripheral
        }
    }
}
