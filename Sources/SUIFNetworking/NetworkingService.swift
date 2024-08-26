//
//  NetworkingService.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Foundation
import Combine
#if os(iOS)
import UIKit.UIImage
#else
import AppKit.NSImage
#endif
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
    
    func setHeader(_ identifier: any NetworkingHeadersCollection.HeaderIdentifier, to value: String?)
}

/// Proxy definition for `Publisher`-based networking
public protocol NetworkingServicePublishersProxyProtocol {
    /// Fetches data from the specified `URL` and decodes it into the provided `Model` type.
    ///
    /// - Parameters:
    ///   - url: The `URL` from which to fetch data.
    /// - Returns: A publisher that delivers a `NetworkingServiceResponse` or an `Error` upon completion.
    func fetch<Model>(from url: URL) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Codable
    
    /// Fetches data from the specified `URL` with optional parameters and decodes it into the provided `Model` type.
    ///
    /// - Parameters:
    ///   - url: The `URL` from which to fetch data.
    ///   - headers: The headers to be included in the request.
    /// - Returns: A publisher that delivers a `NetworkingServiceResponse` or an `Error` upon completion.
    func fetch<Model>(from url: URL, headers: [any NetworkingHeadersCollection.HeaderIdentifier]?) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Codable
    
    /// Fetches data from the specified `URL` with optional parameters and decodes it into the provided `Model` type.
    ///
    /// - Parameters:
    ///   - url: The `URL` from which to fetch data.
    ///   - parameters: Optional parameters for the request.
    /// - Returns: A publisher that delivers a `NetworkingServiceResponse` or an `Error` upon completion.
    func fetch<Model>(from url: URL, parameters: [String: String]?) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Codable
    
    /// Fetches data from the specified `URL` with optional parameters and decodes it into the provided `Model` type.
    ///
    /// - Parameters:
    ///   - url: The `URL` from which to fetch data.
    ///   - headers: The headers to be included in the request.
    ///   - parameters: Optional parameters for the request.
    /// - Returns: A publisher that delivers a `NetworkingServiceResponse` or an `Error` upon completion.
    func fetch<Model>(from url: URL, headers: [any NetworkingHeadersCollection.HeaderIdentifier]?, parameters: [String: String]?) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Codable
    
    /// Fetches an image from the specified URL using the provided `URLRequest`.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` for fetching the image.
    /// - Returns: A publisher that delivers an `NetworkingServiceImageResponse` or an `Error` upon completion.
    func fetchImage(from request: URLRequest) -> AnyPublisher<NetworkingServiceImageResponse, Error>
    
    /// Fetches an image from the specified `URL`.
    ///
    /// - Parameters:
    ///   - url: The `URL` from which to fetch the image.
    /// - Returns: A publisher that delivers an `NetworkingServiceImageResponse` or an `Error` upon completion.
    func fetchImage(from url: URL) -> AnyPublisher<NetworkingServiceImageResponse, Error>
    
    /// Sends a POST request with the input data to the specified `URL` and decodes the output into the provided `Model` type.
    ///
    /// - Parameters:
    ///   - input: The input data to be sent in the request body.
    ///   - url: The URL to which the POST request is sent.
    /// - Returns: A publisher that delivers a response or an error upon completion.
    func post<Input, Output>(_ input: Input, toURL url: URL) -> AnyPublisher<NetworkingServiceResponse<Output>, Error> where Input: Codable, Output: Codable
}

/// Proxy definition for async-based networking
/// A protocol for handling asynchronous networking operations using Swift concurrency.
public protocol NetworkingServiceAsyncProxyProtocol {
    /// Asynchronously fetches data from the specified `URL` with optional parameters and decodes it into the provided `Model` type.
    ///
    /// - Parameters:
    ///   - url: The `URL` from which to fetch data.
    ///   - headers: The headers to be included in the request.
    ///   - parameters: Optional parameters for the request.
    /// - Returns: A `NetworkingServiceResponse` containing the decoded `Model` data.
    func fetch<Model>(from url: URL, headers: [any NetworkingHeadersCollection.HeaderIdentifier]?, parameters: [String: String]?) async throws -> NetworkingServiceResponse<Model> where Model: Codable
    
    /// Asynchronously fetches an image from the specified URL using the provided `URLRequest`.
    ///
    /// - Parameters:
    ///   - request: The `URLRequest` for fetching the image.
    /// - Returns: A `NetworkingServiceImageResponse` containing the fetched image.
    func fetchImage(from request: URLRequest) async throws -> NetworkingServiceImageResponse
    
    /// Asynchronously fetches an image from the specified `URL`.
    ///
    /// - Parameters:
    ///   - url: The `URL` from which to fetch the image.
    /// - Returns: A `NetworkingServiceImageResponse` containing the fetched image.
    func fetchImage(from url: URL) async throws -> NetworkingServiceImageResponse
}

/// `NetworkingService` implementation for centralizing, and configuring your requests and caching
public final class NetworkingService: NetworkingServiceProtocol {
    private static let dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    private static var jsonDecoder: JSONDecoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Self.dateFormat

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
    private static var jsonEncoder: JSONEncoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Self.dateFormat
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        return encoder
    }
    
    public let configuration: URLSessionConfiguration
    public let headersCollection: NetworkingHeadersCollection = NetworkingHeadersCollection()
    public var imageURLCache: URLCache?
    
    public init(configuration: URLSessionConfiguration = .default, imageURLCache: URLCache? = nil) {
        self.configuration = configuration
        self.imageURLCache = imageURLCache
    }
    
    private func fetch<Model>(
        from url: URL,
        headers: [any NetworkingHeadersCollection.HeaderIdentifier]? = nil,
        parameters: [String: String]? = nil
    ) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Codable {
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
        
        var urlRequest = URLRequest(url: finalURL)
        headers?.forEach { header in
            urlRequest.setValue(self.headersCollection[header], forHTTPHeaderField: header.key)
        }
        
        return URLSession(configuration: self.configuration)
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) in
                let model = try Self.jsonDecoder.decode(Model.self, from: data)
                return NetworkingServiceResponse(model: model, response: response)
            }
            .eraseToAnyPublisher()
    }
    
    #if os(iOS)
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
    #elseif os(macOS)
    private func fetchImage(from request: URLRequest) -> AnyPublisher<NetworkingServiceImageResponse, Error> {
        if let response = self.imageURLCache?.cachedResponse(for: request),
            let image = NSImage(data: response.data) {
            return Just(NetworkingServiceImageResponse(image: image, data: response.data, response: response.response))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return URLSession(configuration: self.configuration)
                .dataTaskPublisher(for: request)
                .tryMap { [imageURLCache] (data: Data, response: URLResponse) in
                    guard let image = NSImage(data: data) else {
                        throw NetworkingServiceError.failedToCreateImageFromData
                    }
                    imageURLCache?.storeCachedResponse(CachedURLResponse(response: response, data: data), for: request)
                    return NetworkingServiceImageResponse(image: image, data: data, response: response)
                }
                .eraseToAnyPublisher()
        }
    }
    #endif
    
    private func fetchImage(from url: URL) -> AnyPublisher<NetworkingServiceImageResponse, Error> {
        let request = URLRequest(url: url)
        return fetchImage(from: request)
    }
    
    private func post<Input, Output>(
        _ input: Input,
        toURL url: URL,
        headers: [any NetworkingHeadersCollection.HeaderIdentifier]? = nil
    ) -> AnyPublisher<NetworkingServiceResponse<Output>, Error> where Input: Codable, Output: Codable {
        let configuration = self.configuration
        return Just(input)
            .encode(encoder: Self.jsonEncoder)
            .map { data in
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = "POST"
                urlRequest.httpBody = data
                urlRequest.setValue("application.json", forHTTPHeaderField: "Content-Type")
                
                headers?.forEach { header in
                    urlRequest.setValue(self.headersCollection[header], forHTTPHeaderField: header.key)
                }
                
                return urlRequest
            }
            .flatMap { urlRequest in
                URLSession(configuration: configuration)
                    .dataTaskPublisher(for: urlRequest)
                    .tryMap { (data: Data, response: URLResponse) in
                        let model = try Self.jsonDecoder.decode(Output.self, from: data)
                        return NetworkingServiceResponse(model: model, response: response)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    public func setHeader(_ identifier: any NetworkingHeadersCollection.HeaderIdentifier, to value: String?) {
        self.headersCollection[identifier] = value
    }
}

// MARK: Publishers
extension NetworkingService {
    public struct NetworkingServicePublishersProxy: NetworkingServicePublishersProxyProtocol {
        private let service: NetworkingService
        
        fileprivate init(service: NetworkingService) {
            self.service = service
        }
        
        public func fetch<Model>(from url: URL) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Decodable, Model: Encodable {
            self.service.fetch(from: url)
        }
        
        public func fetch<Model>(from url: URL, headers: [any NetworkingHeadersCollection.HeaderIdentifier]?) -> AnyPublisher<NetworkingServiceResponse<Model>, any Error> where Model : Decodable, Model : Encodable {
            self.service.fetch(from: url, headers: headers)
        }
        
        public func fetch<Model>(from url: URL, parameters: [String: String]?) -> AnyPublisher<NetworkingServiceResponse<Model>, Error> where Model: Decodable, Model: Encodable {
            self.service.fetch(from: url, parameters: parameters)
        }
        
        public func fetch<Model>(from url: URL, headers: [any NetworkingHeadersCollection.HeaderIdentifier]?, parameters: [String : String]?) -> AnyPublisher<NetworkingServiceResponse<Model>, any Error> where Model : Decodable, Model : Encodable {
            self.service.fetch(from: url, headers: headers, parameters: parameters)
        }
        
        public func fetchImage(from request: URLRequest) -> AnyPublisher<NetworkingServiceImageResponse, Error> {
            self.service.fetchImage(from: request)
        }
        
        public func fetchImage(from url: URL) -> AnyPublisher<NetworkingServiceImageResponse, Error> {
            self.service.fetchImage(from: url)
        }
        
        public func post<Input, Output>(_ input: Input, toURL url: URL) -> AnyPublisher<NetworkingServiceResponse<Output>, Error> where Input: Codable, Output: Codable {
            self.service.post(input, toURL: url)
        }
    }
    
    public var publishers: some NetworkingServicePublishersProxyProtocol {
        NetworkingServicePublishersProxy(service: self)
    }
}

// MARK: Async
extension NetworkingService {
    public struct NetworkingServiceAsyncProxy: NetworkingServiceAsyncProxyProtocol {
        private let service: NetworkingService
        
        fileprivate init(service: NetworkingService) {
            self.service = service
        }
        
        public func fetch<Model>(
            from url: URL,
            headers: [any NetworkingHeadersCollection.HeaderIdentifier]?,
            parameters: [String: String]?
        ) async throws -> NetworkingServiceResponse<Model> where Model: Decodable, Model: Encodable {
            try await self.service.fetch(from: url, headers: headers, parameters: parameters).async()
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
