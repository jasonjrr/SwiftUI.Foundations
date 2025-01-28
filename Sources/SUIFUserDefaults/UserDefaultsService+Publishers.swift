//
//  UserDefaultsService+Publishers.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/28/25.
//

import Foundation
import Combine

extension UserDefaultsService {
    public struct Publishers: UserDefaultsServicePublishersProtocol {
        private let parent: UserDefaultsService
        
        init(parent: UserDefaultsService) {
            self.parent = parent
        }
        
        public func bool<K>(for key: K) -> AnyPublisher<Bool, Never> where K : UserDefaults.Key {
            self.parent.bool(for: key).eraseToAnyPublisher()
        }
        
        public func data<K>(for key: K) -> AnyPublisher<Data?, Never> where K : UserDefaults.Key {
            self.parent.data(for: key).eraseToAnyPublisher()
        }
        
        public func double<K>(for key: K) -> AnyPublisher<Double, Never> where K : UserDefaults.Key {
            self.parent.double(for: key).eraseToAnyPublisher()
        }
        
        public func float<K>(for key: K) -> AnyPublisher<Float, Never> where K : UserDefaults.Key {
            self.parent.float(for: key).eraseToAnyPublisher()
        }
        
        public func integer<K>(for key: K) -> AnyPublisher<Int, Never> where K : UserDefaults.Key {
            self.parent.integer(for: key).eraseToAnyPublisher()
        }
        
        public func object<K, T>(for key: K) -> AnyPublisher<T?, Never> where K : UserDefaults.Key, T : Codable {
            self.parent.object(for: key).eraseToAnyPublisher()
        }
        
        public func string<K>(for key: K) -> AnyPublisher<String?, Never> where K : UserDefaults.Key {
            self.parent.string(for: key).eraseToAnyPublisher()
        }
        
        public func stringArray<K>(for key: K) -> AnyPublisher<[String]?, Never> where K : UserDefaults.Key {
            self.parent.stringArray(for: key).eraseToAnyPublisher()
        }
    }
    
    public var publishers: some UserDefaultsServicePublishersProtocol {
        Publishers(parent: self)
    }
}
