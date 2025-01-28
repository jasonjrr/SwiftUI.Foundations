//
//  UserDefaultsService+Async.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/28/25.
//

import Foundation
import SwiftUIFoundation

extension UserDefaultsService {
    public actor Async: UserDefaultsServiceAsyncProtocol, @unchecked Sendable {
        private weak var parent: UserDefaultsService?
        private let onError: (Error, CallerMetadata) -> Void
        
        init(parent: UserDefaultsService, onError: @escaping @Sendable (Error, CallerMetadata) -> Void) {
            self.parent = parent
            self.onError = onError
        }
        
        public func bool<K>(for key: K) async -> Bool where K : UserDefaults.Key {
            do {
                guard let parent else {
                    throw Errors.parentUserDefaultsServiceNoLongerExists
                }
                return try await parent.bool(for: key).eraseToAnyPublisher().async()
            } catch {
                self.onError(error, .metadata())
                return false
            }
        }
        
        public func data<K>(for key: K) async -> Data? where K : UserDefaults.Key {
            do {
                guard let parent else {
                    throw Errors.parentUserDefaultsServiceNoLongerExists
                }
                return try await parent.data(for: key).eraseToAnyPublisher().async()
            } catch {
                self.onError(error, .metadata())
                return nil
            }
        }
        
        public func double<K>(for key: K) async -> Double where K : UserDefaults.Key {
            do {
                guard let parent else {
                    throw Errors.parentUserDefaultsServiceNoLongerExists
                }
                return try await parent.double(for: key).eraseToAnyPublisher().async()
            } catch {
                self.onError(error, .metadata())
                return 0.0
            }
        }
        
        public func float<K>(for key: K) async -> Float where K : UserDefaults.Key {
            do {
                guard let parent else {
                    throw Errors.parentUserDefaultsServiceNoLongerExists
                }
                return try await parent.float(for: key).eraseToAnyPublisher().async()
            } catch {
                self.onError(error, .metadata())
                return 0.0
            }
        }
        
        public func integer<K>(for key: K) async -> Int where K : UserDefaults.Key {
            do {
                guard let parent else {
                    throw Errors.parentUserDefaultsServiceNoLongerExists
                }
                return try await parent.integer(for: key).eraseToAnyPublisher().async()
            } catch {
                self.onError(error, .metadata())
                return 0
            }
        }
        
        public func object<K, T>(for key: K) async -> T? where K : UserDefaults.Key, T : Codable & Sendable {
            do {
                guard let parent else {
                    throw Errors.parentUserDefaultsServiceNoLongerExists
                }
                return try await parent.object(for: key).eraseToAnyPublisher().async()
            } catch {
                self.onError(error, .metadata())
                return nil
            }
        }
        
        public func string<K>(for key: K) async -> String? where K : UserDefaults.Key {
            do {
                guard let parent else {
                    throw Errors.parentUserDefaultsServiceNoLongerExists
                }
                return try await parent.string(for: key).eraseToAnyPublisher().async()
            } catch {
                self.onError(error, .metadata())
                return nil
            }
        }
        
        public func stringArray<K>(for key: K) async -> [String]? where K : UserDefaults.Key {
            do {
                guard let parent else {
                    throw Errors.parentUserDefaultsServiceNoLongerExists
                }
                return try await parent.stringArray(for: key).eraseToAnyPublisher().async()
            } catch {
                self.onError(error, .metadata())
                return nil
            }
        }
    }
}

extension UserDefaultsService.Async {
    enum Errors: LocalizedError {
        case parentUserDefaultsServiceNoLongerExists
    }
}
