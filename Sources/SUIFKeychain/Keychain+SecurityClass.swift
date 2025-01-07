//
//  SecurityClass.swift
//  
//
//  Created by Jason Lew-Rapai on 4/15/24.
//

import Foundation

extension Keychain {
    public enum SecurityClass {
        case internetPassword
        case genericPassword
        case certificate
        case key
        case identity
        
        internal var cfString: CFString {
            switch self {
            case .internetPassword: return kSecClassInternetPassword
            case .genericPassword: return kSecClassGenericPassword
            case .certificate: return kSecClassCertificate
            case .key: return kSecClassKey
            case .identity: return kSecClassIdentity
            }
        }
    }
}
