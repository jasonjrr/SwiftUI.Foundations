//
//  Binding+Sanitize.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Foundation
import SwiftUI

public enum SanitizationOption {
    case allowedCharacters(CharacterSet)
    case limit(Int)
    case numericOnly
}

extension Binding where Value == String {
    public func sanitize(_ options: [SanitizationOption]) -> Self {
        var newValue = self.wrappedValue
        var didUpdate = false
        
        options.forEach { option in
            switch option {
            case .allowedCharacters(let characterSet):
                let cleanString = newValue
                    .components(separatedBy: characterSet.inverted)
                    .joined()
                if newValue != cleanString {
                    newValue = cleanString
                    didUpdate = true
                }
                
            case .limit(let limit):
                if newValue.count > limit {
                    newValue = String(newValue.prefix(limit))
                    didUpdate = true
                }
                
            case .numericOnly:
                let cleanString = newValue
                    .components(separatedBy: CharacterSet.decimalDigits.inverted)
                    .joined()
                if newValue != cleanString {
                    newValue = cleanString
                    didUpdate = true
                }
            }
        }
        
        if didUpdate {
            DispatchQueue.main.async {
                self.wrappedValue = newValue
            }
        }
        return self
    }
    
    public func limit(_ limit: Int) -> Self {
        sanitize([.limit(limit)])
    }
    
    public func numericOnly() -> Self {
        sanitize([.numericOnly])
    }
}
