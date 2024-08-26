//
//  NetworkingHeadersCollection.swift
//
//
//  Created by Jason Lew-Rapai on 6/24/24.
//

import Foundation

public class NetworkingHeadersCollection {
    private var headersByKey: [HeaderIdentifierKey: String] = [:]
    
    public subscript(identifier: any HeaderIdentifier) -> String? {
        get {
            return self.headersByKey[HeaderIdentifierKey(identifier: identifier)]
        }
        set {
            if let newValue = newValue {
                self.headersByKey[HeaderIdentifierKey(identifier: identifier)] = newValue
            } else {
                self.headersByKey.removeValue(forKey: HeaderIdentifierKey(identifier: identifier))
            }
        }
    }
}

extension NetworkingHeadersCollection {
    public protocol HeaderIdentifier: Equatable, Hashable {
        var key: String { get }
    }
    
    fileprivate struct HeaderIdentifierKey: Equatable, Hashable {
        let identifier: any HeaderIdentifier
        
        init(identifier: any HeaderIdentifier) {
            self.identifier = identifier
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.identifier)
        }
        
        static func ==(lhs: NetworkingHeadersCollection.HeaderIdentifierKey, rhs: NetworkingHeadersCollection.HeaderIdentifierKey) -> Bool {
            lhs.identifier.key == rhs.identifier.key
        }
    }
}

extension NetworkingHeadersCollection {
    struct AccessTokenHeaderIdentifier: NetworkingHeadersCollection.HeaderIdentifier {
        let key: String = "x-access-token"
    }
}

extension NetworkingHeadersCollection.HeaderIdentifier where Self == NetworkingHeadersCollection.AccessTokenHeaderIdentifier {
    static var accessToken: any NetworkingHeadersCollection.HeaderIdentifier {
        return NetworkingHeadersCollection.AccessTokenHeaderIdentifier()
    }
}

extension Array where Element : NetworkingHeadersCollection.HeaderIdentifier {
    public static var authenticationRequired: [any NetworkingHeadersCollection.HeaderIdentifier] {
        [
            NetworkingHeadersCollection.AccessTokenHeaderIdentifier(),
        ]
    }
}

extension Optional where Wrapped == [any NetworkingHeadersCollection.HeaderIdentifier] {
    public static var authenticationRequired: [any NetworkingHeadersCollection.HeaderIdentifier]? {
        [
            NetworkingHeadersCollection.AccessTokenHeaderIdentifier(),
        ]
    }
}
