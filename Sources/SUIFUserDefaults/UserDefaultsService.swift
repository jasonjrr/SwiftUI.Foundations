//
//  UserDefaultsService.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/28/25.
//

import Foundation
import Combine
import SwiftUIFoundation

public protocol UserDefaultsServiceProtocol: AnyObject, Sendable {
    associatedtype PublishersProxy : UserDefaultsServicePublishersProtocol
    associatedtype AsyncProxy : UserDefaultsServiceAsyncProtocol
    
    var publishers: Self.PublishersProxy { get }
    var async: Self.AsyncProxy { get }
    
    func set<K: UserDefaults.Key>(_ bool: Bool, for key: K)
    func set<K: UserDefaults.Key>(_ data: Data?, for key: K)
    func set<K: UserDefaults.Key>(_ double: Double, for key: K)
    func set<K: UserDefaults.Key>(_ float: Float, for key: K)
    func set<K: UserDefaults.Key>(_ integer: Int, for key: K)
    func set<K: UserDefaults.Key, T: Codable>(_ object: T?, for key: K)
    func set<K: UserDefaults.Key>(_ string: String?, for key: K)
    func set<K: UserDefaults.Key>(_ stringArray: [String]?, for key: K)
}

public protocol UserDefaultsServicePublishersProtocol: Sendable {
    func bool<K: UserDefaults.Key>(for key: K) -> AnyPublisher<Bool, Never>
    func data<K: UserDefaults.Key>(for key: K) -> AnyPublisher<Data?, Never>
    func double<K: UserDefaults.Key>(for key: K) -> AnyPublisher<Double, Never>
    func float<K: UserDefaults.Key>(for key: K) -> AnyPublisher<Float, Never>
    func integer<K: UserDefaults.Key>(for key: K) -> AnyPublisher<Int, Never>
    func object<K: UserDefaults.Key, T: Codable>(for key: K) -> AnyPublisher<T?, Never>
    func string<K: UserDefaults.Key>(for key: K) -> AnyPublisher<String?, Never>
    func stringArray<K: UserDefaults.Key>(for key: K) -> AnyPublisher<[String]?, Never>
}

public protocol UserDefaultsServiceAsyncProtocol: AnyObject, Sendable {
    func bool<K: UserDefaults.Key>(for key: K) async -> Bool
    func data<K: UserDefaults.Key>(for key: K) async -> Data?
    func double<K: UserDefaults.Key>(for key: K) async -> Double
    func float<K: UserDefaults.Key>(for key: K) async -> Float
    func integer<K: UserDefaults.Key>(for key: K) async -> Int
    func object<K: UserDefaults.Key, T: Codable>(for key: K) async -> T?
    func string<K: UserDefaults.Key>(for key: K) async -> String?
    func stringArray<K: UserDefaults.Key>(for key: K) async -> [String]?
}

public final class UserDefaultsService: UserDefaultsServiceProtocol, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private var boolCache: [String: CurrentValueSubject<Bool, Never>] = [:]
    private var dataCache: [String: CurrentValueSubject<Data?, Never>] = [:]
    private var doubleCache: [String: CurrentValueSubject<Double, Never>] = [:]
    private var floatCache: [String: CurrentValueSubject<Float, Never>] = [:]
    private var integerCache: [String: CurrentValueSubject<Int, Never>] = [:]
    private var objectCache: [String: AnyObject] = [:]
    private var stringCache: [String: CurrentValueSubject<String?, Never>] = [:]
    private var stringArrayCache: [String: CurrentValueSubject<[String]?, Never>] = [:]
    
    let onError: (Error, CallerMetadata) -> Void
    
    private var _async: UserDefaultsService.Async!
    public var async: some UserDefaultsServiceAsyncProtocol { self._async }
    
    public init(userDefaults: UserDefaults = UserDefaults.standard, onError: @escaping @Sendable (Error, CallerMetadata) -> Void) {
        self.userDefaults = userDefaults
        self.onError = onError
        self._async = Async(parent: self, onError: onError)
    }
    
    func bool<K: UserDefaults.Key>(for key: K) -> CurrentValueSubject<Bool, Never> {
        if let subject = self.boolCache[key.rawValue] {
            return subject
        } else {
            let value = self.userDefaults.bool(forKey: key.rawValue)
            let subject: CurrentValueSubject<Bool, Never> = CurrentValueSubject(value)
            self.boolCache[key.rawValue] = subject
            return subject
        }
    }
    
    func data<K: UserDefaults.Key>(for key: K) -> CurrentValueSubject<Data?, Never> {
        if let subject = self.dataCache[key.rawValue] {
            return subject
        } else {
            let value = self.userDefaults.data(forKey: key.rawValue)
            let subject: CurrentValueSubject<Data?, Never> = CurrentValueSubject(value)
            self.dataCache[key.rawValue] = subject
            return subject
        }
    }
    
    func double<K: UserDefaults.Key>(for key: K) -> CurrentValueSubject<Double, Never> {
        if let subject = self.doubleCache[key.rawValue] {
            return subject
        } else {
            let value = self.userDefaults.double(forKey: key.rawValue)
            let subject: CurrentValueSubject<Double, Never> = CurrentValueSubject(value)
            self.doubleCache[key.rawValue] = subject
            return subject
        }
    }
    
    func float<K: UserDefaults.Key>(for key: K) -> CurrentValueSubject<Float, Never> {
        if let subject = self.floatCache[key.rawValue] {
            return subject
        } else {
            let value = self.userDefaults.float(forKey: key.rawValue)
            let subject: CurrentValueSubject<Float, Never> = CurrentValueSubject(value)
            self.floatCache[key.rawValue] = subject
            return subject
        }
    }
    
    func integer<K: UserDefaults.Key>(for key: K) -> CurrentValueSubject<Int, Never> {
        if let subject = self.integerCache[key.rawValue] {
            return subject
        } else {
            let value = self.userDefaults.integer(forKey: key.rawValue)
            let subject: CurrentValueSubject<Int, Never> = CurrentValueSubject(value)
            self.integerCache[key.rawValue] = subject
            return subject
        }
    }
    
    func object<K: UserDefaults.Key, T: Codable>(for key: K) -> CurrentValueSubject<T?, Never> {
        if let subject = self.objectCache[key.rawValue] as? CurrentValueSubject<T?, Never> {
            return subject
        } else {
            let value = self.userDefaults.object(forKey: key.rawValue) as? T
            let subject: CurrentValueSubject<T?, Never> = CurrentValueSubject(value)
            self.objectCache[key.rawValue] = subject
            return subject
        }
    }
    
    func string<K: UserDefaults.Key>(for key: K) -> CurrentValueSubject<String?, Never> {
        if let subject = self.stringCache[key.rawValue] {
            return subject
        } else {
            let value = self.userDefaults.string(forKey: key.rawValue)
            let subject: CurrentValueSubject<String?, Never> = CurrentValueSubject(value)
            self.stringCache[key.rawValue] = subject
            return subject
        }
    }
    
    func stringArray<K: UserDefaults.Key>(for key: K) -> CurrentValueSubject<[String]?, Never> {
        if let subject = self.stringArrayCache[key.rawValue] {
            return subject
        } else {
            let value = self.userDefaults.stringArray(forKey: key.rawValue)
            let subject: CurrentValueSubject<[String]?, Never> = CurrentValueSubject(value)
            self.stringArrayCache[key.rawValue] = subject
            return subject
        }
    }
    
    public func set<K: UserDefaults.Key>(_ bool: Bool, for key: K) {
        self.userDefaults.set(bool, forKey: key.rawValue)
        self.bool(for: key).send(bool)
    }
    
    public func set<K: UserDefaults.Key>(_ data: Data?, for key: K) {
        self.userDefaults.set(data, forKey: key.rawValue)
        self.data(for: key).send(data)
    }
    
    public func set<K: UserDefaults.Key>(_ double: Double, for key: K) {
        self.userDefaults.set(double, forKey: key.rawValue)
        self.double(for: key).send(double)
    }
    
    public func set<K: UserDefaults.Key>(_ float: Float, for key: K) {
        self.userDefaults.set(float, forKey: key.rawValue)
        self.float(for: key).send(float)
    }
    
    public func set<K: UserDefaults.Key>(_ integer: Int, for key: K) {
        self.userDefaults.set(integer, forKey: key.rawValue)
        self.integer(for: key).send(integer)
    }
    
    public func set<K: UserDefaults.Key, T: Codable>(_ object: T?, for key: K) {
        self.userDefaults.set(object, forKey: key.rawValue)
        self.object(for: key).send(object)
    }
    
    public func set<K: UserDefaults.Key>(_ string: String?, for key: K) {
        self.userDefaults.set(string, forKey: key.rawValue)
        self.string(for: key).send(string)
    }
    
    public func set<K: UserDefaults.Key>(_ stringArray: [String]?, for key: K) {
        self.userDefaults.set(stringArray, forKey: key.rawValue)
        self.stringArray(for: key).send(stringArray)
    }
}
