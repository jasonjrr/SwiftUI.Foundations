//
//  SourcedImageViewModel.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Foundation
import Combine
import UIKit.UIImage
import SwiftUIFoundation
import SUIFNetworking

/// `ViewModel` that handles images from a variety of sources
public class SourcedImageViewModel: ObservableObject, Identifiable {
    public enum Errors: Error {
        case invalidState
        case unableToFindSystemImage
        case invalidImageURL
        case unableToFetchImage
    }
    public enum ImageSource {
        /// No source image
        case empty
        /// System image from SFSymbols
        case systemImage(named: String)
        case uiImage(UIImage)
        /// URL source for the image which will attempt to be lazy loaded a chached within this `SourcedImageViewModel`
        case url(String)
    }
    public enum ImageState {
        case empty
        case systemImage(named: String)
        case loading
        case loaded(UIImage)
        case error(Error)
    }
    
    private let networkingService: any NetworkingServiceProtocol
    private let onError: ((Error) -> Void)?
    
    private let readyToLoadImage: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    /// `Subject` containing the source of the image. If changed this may cause the actual image to be refetched.
    public let imageSource: CurrentValueSubject<ImageSource, Never>
    private let _imageState: CurrentValueSubject<ImageState, Never> = CurrentValueSubject(.empty)
    /// Current state of the image
    public var imageState: AnyPublisher<ImageState, Never> { self._imageState.eraseToAnyPublisher() }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let fetchImagesDistpatchQueue = DispatchQueue(label: "SourcedImageViewModel", qos: .userInitiated)
    
    /// Initializes a new `SourcedImageViewModel`
    ///
    /// - Parameters:
    ///   - source: The source for the image that will be fetched as needed
    ///   - networkingService: Service that manages fetching and possibly caching of images
    ///   - onError: Closure called when an ``Error`` occurs within this `ViewModel`
    public init(source: ImageSource, networkingService: some NetworkingServiceProtocol, onError: ((Error) -> Void)? = nil) {
        self.imageSource = CurrentValueSubject(source)
        self.networkingService = networkingService
        self.onError = onError
        
        self.readyToLoadImage
            .filter { $0 }
            .combineLatest(self.imageSource) { $1 }
            .withLatestFrom(self.imageState) { ($0, $1) }
            .sink(receiveValue: { [weak self] source, oldState in
                var fromURL: Bool = false
                switch source {
                case .empty:
                    self?._imageState.send(.empty)
                case .systemImage(let name):
                    self?._imageState.send(.systemImage(named: name))
                case .uiImage(let uiImage):
                    self?._imageState.send(.loaded(uiImage))
                case .url:
                    self?._imageState.send(.loading)
                    fromURL = true
                }
                
                switch oldState {
                case .loading, .error:
                    self?.fetchImage()
                case .empty, .systemImage, .loaded:
                    if fromURL {
                        self?.fetchImage()
                    }
                }
            })
            .store(in: &self.cancellables)
    }
    
    /// Initializes a new `SourcedImageViewModel`
    ///
    /// - Parameters:
    ///   - source: The source for the image that will be fetched as needed
    ///   - urlImageCache: Cache where images fetched from URLs are stored. When `nil` images are fetched and stored in this ViewModel only.
    ///   - onError: Closure called when an ``Error`` occurs within this `ViewModel`
    public convenience init(source: ImageSource, imageURLCache: URLCache? = nil, onError: ((Error) -> Void)? = nil) {
        self.init(source: source, networkingService: NetworkingService(imageURLCache: imageURLCache), onError: onError)
    }
    
    /// Marks the ready state and begins loading the image from the specified `imageSource`
    public func markReady() {
        if self.readyToLoadImage.value {
            return
        }
        self.readyToLoadImage.send(true)
    }
    
    private func fetchImage() {
        self._imageState
            .first()
            .filter { state in
                switch state {
                case .error, .loading:
                    return true
                case .systemImage, .loaded, .empty:
                    return false
                }
            }
            .withLatestFrom(self.imageSource) { ($0, $1) }
            .receive(on: self.fetchImagesDistpatchQueue)
            .flatMap { [weak self, networkingService] (_: ImageState, imageSource: ImageSource) -> AnyPublisher<ImageState, Never> in
                switch imageSource {
                case .empty, .systemImage, .uiImage:
                    // This should not be able to happen due to the filer above.
                    let error = Errors.invalidState
                    self?.onError?(error)
                    return Just(.error(error)).eraseToAnyPublisher()
                    
                case .url(let urlString):
                    guard let url = URL(string: urlString) else {
                        let error = Errors.invalidImageURL
                        self?.onError?(error)
                        return Just(.error(error)).eraseToAnyPublisher()
                    }
                    return networkingService
                        .publishers
                        .fetchImage(from: url)
                        .map { response -> ImageState in
                            .loaded(response.image)
                        }
                        .mapError { [weak self] error in
                            self?.onError?(error)
                            return error
                        }
                        .replaceError(with: .error(Errors.unableToFetchImage))
                        .eraseToAnyPublisher()
                }
            }
            .sink(receiveValue: { [weak self] in
                self?._imageState.send($0)
            })
            .store(in: &self.cancellables)
    }
}
