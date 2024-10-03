//
//  ScanOption.swift
//
//
//  Created by Jason Lew-Rapai on 8/29/24.
//

import Foundation
import CoreBluetooth

extension Bluetooth {
    public enum ScanOption: Equatable {
        case allowDuplicates(Bool)
        case solicitedServiceUUIDs([CBUUID])
        
        internal var key: String {
            switch self {
            case .allowDuplicates:
                return CBCentralManagerScanOptionAllowDuplicatesKey
            case .solicitedServiceUUIDs:
                return CBCentralManagerScanOptionSolicitedServiceUUIDsKey
            }
        }
        
        internal var value: Any {
            switch self {
            case .allowDuplicates(let value):
                return value
            case .solicitedServiceUUIDs(let uuids):
                return NSArray(array: uuids)
            }
        }
        
        public static func == (lhs: ScanOption, rhs: ScanOption) -> Bool {
            switch (lhs, rhs) {
            case (.allowDuplicates(let lhsValue), .allowDuplicates(let rhsValue)):
                return lhsValue == rhsValue
            case (.solicitedServiceUUIDs(let lhsValue), .solicitedServiceUUIDs(let rhsValue)):
                return lhsValue == rhsValue
            default:
                return false
            }
        }
    }
}

extension Array where Element == Bluetooth.ScanOption {
    func toDictionary() -> [String: Any]? {
        var dictionary: [String: Any] = [:]
        forEach { option in
            dictionary[option.key] = option.value
        }
        return dictionary.isEmpty ? nil : dictionary
    }
}
