//
//  NetworkingService.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Foundation
import Combine
import UIKit.UIImage
import SwiftUIFoundation

/// Service definition for centralized networking control
public protocol NetworkingServiceProtocol: AnyObject {
    associatedtype PublishersProxy : NetworkingServicePublishersProxyProtocol
    associatedtype AsyncProxy : NetworkingServiceAsyncProxyProtocol
    
    var imageURLCache: URLCache? { get set }
    
    /// `PublishersProxy` adhering to `NetworkingServicePublishersProxyProtocol`
    /// - Returns: A concrete implementation of `NetworkingServicePublishersProxyProtocol`
    var publishers: Self.PublishersProxy { get }
    
    /// `AsyncProxy` adhering to `NetworkingServiceAsyncProxyProtocol`
    /// - Returns: A concrete implementation of `NetworkingServiceAsyncProxyProtocol`
    var async: Self.AsyncProxy { get }
}

/// Proxy definition for `Publisher`-based networking
public protocol NetworkingServicePublishersProxyProtocol {
    func fetch<Model>(from url: URL) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Codable
    func fetch<Model>(from url: URL, parameters: [String: String]?) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Codable
    func fetchImage(from request: URLRequest) -> AnyPublisher<NetworkingServiceImageResponse, Error>
    func fetchImage(from url: URL) -> AnyPublisher<NetworkingServiceImageResponse, Error>
}

/// Proxy definition for async-based networking
public protocol NetworkingServiceAsyncProxyProtocol {
    func fetch<Model>(from url: URL, parameters: [String: String]?) async throws -> NetworkingServiceResponse<Model> where Model: Codable
    func fetchImage(from request: URLRequest) async throws -> NetworkingServiceImageResponse
    func fetchImage(from url: URL) async throws -> NetworkingServiceImageResponse
}

/// `NetworkingService` implementation for centralizing, and configuring your requests and caching
public final class NetworkingService: NetworkingServiceProtocol {
    public let configuration: URLSessionConfiguration
    public var imageURLCache: URLCache?
    
    public init(configuration: URLSessionConfiguration = .default, imageURLCache: URLCache? = nil) {
        self.configuration = configuration
        self.imageURLCache = imageURLCache
    }
    
    private func fetch<Model>(from url: URL, parameters: [String: String]? = nil) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Codable {
        let finalURL: URL
        if let parameters = parameters {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return Fail(error: NetworkingServiceError.malformedURL).eraseToAnyPublisher()
            }
            urlComponents.queryItems = parameters.map { (key: String, value: String) in
                URLQueryItem(name: key, value: value)
            }
            guard let url = urlComponents.url else {
                return Fail(error: NetworkingServiceError.malformedURL).eraseToAnyPublisher()
            }
            finalURL = url
        } else {
            finalURL = url
        }
        
        return URLSession(configuration: self.configuration)
            .dataTaskPublisher(for: finalURL)
            .tryMap { (data: Data, response: URLResponse) in
                let model = try JSONDecoder().decode(Model.self, from: data)
                return NetworkingServiceResponse(model: model, response: response)
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchImage(from request: URLRequest) -> AnyPublisher<NetworkingServiceImageResponse, Error> {
        if let response = self.imageURLCache?.cachedResponse(for: request),
            let image = UIImage(data: response.data) {
            return Just(NetworkingServiceImageResponse(image: image, data: response.data, response: response.response))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return URLSession(configuration: self.configuration)
                .dataTaskPublisher(for: request)
                .tryMap { [imageURLCache] (data: Data, response: URLResponse) in
                    guard let image = UIImage(data: data) else {
                        throw NetworkingServiceError.failedToCreateImageFromData
                    }
                    imageURLCache?.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                    return NetworkingServiceImageResponse(image: image, data: data, response: response)
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func fetchImage(from url: URL) -> AnyPublisher<NetworkingServiceImageResponse, Error> {
        let request = URLRequest(url: url)
        return fetchImage(from: request)
    }
}

extension NetworkingService {
    public struct NetworkingServicePublishersProxy: NetworkingServicePublishersProxyProtocol {
        private let service: NetworkingService
        
        fileprivate init(service: NetworkingService) {
            self.service = service
        }
        
        public func fetch<Model>(from url: URL) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Decodable, Model: Encodable {
            self.service.fetch(from: url)
        }
        
        public func fetch<Model>(from url: URL, parameters: [String: String]?) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Decodable, Model: Encodable {
            self.service.fetch(from: url, parameters: parameters)
        }
        
        public func fetchImage(from request: URLRequest) -> AnyPublisher<NetworkingServiceImageResponse, Error> {
            self.service.fetchImage(from: request)
        }
        
        public func fetchImage(from url: URL) -> AnyPublisher<NetworkingServiceImageResponse, Error> {
            self.service.fetchImage(from: url)
        }
    }
    
    public var publishers: some NetworkingServicePublishersProxyProtocol {
        NetworkingServicePublishersProxy(service: self)
    }
}

extension NetworkingService {
    public struct NetworkingServiceAsyncProxy: NetworkingServiceAsyncProxyProtocol {
        private let service: NetworkingService
        
        fileprivate init(service: NetworkingService) {
            self.service = service
        }
        
        public func fetch<Model>(from url: URL, parameters: [String: String]?) async throws -> NetworkingServiceResponse<Model> where Model: Decodable, Model: Encodable {
            try await self.service.fetch(from: url, parameters: parameters).async()
        }
        
        public func fetchImage(from request: URLRequest) async throws -> NetworkingServiceImageResponse {
            try await self.service.fetchImage(from: request).async()
        }
        
        public func fetchImage(from url: URL) async throws -> NetworkingServiceImageResponse {
            try await self.service.fetchImage(from: url).async()
        }
    }
    
    public var async: some NetworkingServiceAsyncProxyProtocol {
        NetworkingServiceAsyncProxy(service: self)
    }
}
