//
//  QueryError.swift
//
//
//  Created by Jason Lew-Rapai on 4/15/24.
//

import Foundation

extension Keychain {
    /// Errors that can be thrown when the Keychain is queried.
    public enum QueryError: LocalizedError {
        /// The requested item was not found in the Keychain.
        case itemNotFound
        /// Attempted to save an item that already exists.
        /// Update the item instead.
        case duplicateItem
        ///
        case unableToGetData
        ///
        case unableToGetToken
        /// The operation resulted in an unexpected status.
        case unexpectedStatus(OSStatus)
    }
}
