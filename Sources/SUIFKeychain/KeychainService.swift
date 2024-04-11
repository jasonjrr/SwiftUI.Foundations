//
//  KeychainService.swift
//
//
//  Created by Jason Lew-Rapai on 4/15/24.
//

import Foundation

extension Keychain {
    public protocol KeychainServiceProtocol: AnyObject {
        func save(data: Data, identifier: String, service: String, securityClass: SecurityClass) throws
        func save(tokenString: String, identifier: String, service: String) throws
        
        func getData(identifier: String, service: String, securityClass: SecurityClass) throws -> Data
        func getToken(identifier: String, service: String) throws -> String
        
        func update(data: Data, identifier: String, service: String, securityClass: SecurityClass) throws
        func update(tokenString: String, identifier: String, service: String) throws
        
        func upsert(data: Data, identifier: String, service: String, securityClass: SecurityClass) throws
        func upsert(tokenString: String, identifier: String, service: String) throws
        
        func delete(identifier: String, service: String, securityClass: SecurityClass) throws
    }
}

extension Keychain {
    public class KeychainService: KeychainServiceProtocol {
        public func save(data: Data, identifier: String, service: String, securityClass: SecurityClass) throws {
            let attributes = [
                kSecClass: securityClass.cfString,
                kSecAttrService: service,
                kSecAttrAccount: identifier,
                kSecValueData: data
            ] as CFDictionary

            let status = SecItemAdd(attributes, nil)
            guard status == errSecSuccess else {
                if status == errSecDuplicateItem {
                    throw QueryError.duplicateItem
                }
                throw QueryError.unexpectedStatus(status)
            }
        }
        
        public func save(tokenString: String, identifier: String, service: String) throws {
            try save(
                data: Data(tokenString.utf8),
                identifier: identifier, 
                service: service,
                securityClass: .genericPassword)
        }
        
        public func getData(identifier: String, service: String, securityClass: SecurityClass) throws -> Data {
            let query = [
                kSecClass: securityClass.cfString,
                kSecAttrService: service,
                kSecAttrAccount: identifier,
                kSecMatchLimit: kSecMatchLimitOne,
                kSecReturnData: true
            ] as CFDictionary
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query, &result)
            
            if status == errSecSuccess {
                if let data = result as? Data {
                    return data
                } else {
                    throw QueryError.unableToGetData
                }
            } else if status == errSecItemNotFound {
                throw QueryError.itemNotFound
            } else {
                throw QueryError.unexpectedStatus(status)
            }
        }
        
        public func getToken(identifier: String, service: String) throws -> String {
            let data = try getData(identifier: identifier, service: service, securityClass: .genericPassword)
            guard let tokenString = String(data: data, encoding: .utf8) else {
                throw QueryError.unableToGetToken
            }
            return tokenString
        }
        
        public func update(data: Data, identifier: String, service: String, securityClass: SecurityClass) throws {
            let query = [
                kSecClass: securityClass.cfString,
                kSecAttrService: service,
                kSecAttrAccount: identifier
            ] as CFDictionary

            let attributes = [
                kSecValueData: data
            ] as CFDictionary

            let status = SecItemUpdate(query, attributes)
            if status == errSecItemNotFound {
                throw QueryError.itemNotFound
            } else if status != errSecSuccess {
                throw QueryError.unexpectedStatus(status)
            }
        }
        
        public func update(tokenString: String, identifier: String, service: String) throws {
            try update(
                data: Data(tokenString.utf8),
                identifier: identifier,
                service: service,
                securityClass: .genericPassword)
        }
        
        public func upsert(data: Data, identifier: String, service: String, securityClass: SecurityClass) throws {
            do {
                _ = try getData(identifier: identifier, service: service, securityClass: securityClass)
                try update(data: data, identifier: identifier, service: service, securityClass: securityClass)
            } catch QueryError.itemNotFound {
                try save(data: data, identifier: identifier, service: service, securityClass: securityClass)
            }
        }
        
        public func upsert(tokenString: String, identifier: String, service: String) throws {
            do {
                _ = try getToken(identifier: identifier, service: service)
                try update(tokenString: tokenString, identifier: identifier, service: service)
            } catch QueryError.itemNotFound {
                try save(tokenString: tokenString, identifier: identifier, service: service)
            }
        }
        
        public func delete(identifier: String, service: String, securityClass: SecurityClass) throws {
            let query = [
                kSecClass: securityClass.cfString,
                kSecAttrService: service,
                kSecAttrAccount: identifier
            ] as CFDictionary

            let status = SecItemDelete(query)
            if status != errSecSuccess && status != errSecItemNotFound {
                throw QueryError.unexpectedStatus(status)
            }
        }
    }
}
