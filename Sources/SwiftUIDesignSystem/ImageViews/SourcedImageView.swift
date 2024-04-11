//
//  SourcedImageView.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// Scaling of the sourced image
public enum SourcedImageScaling {
    case scaleToFit
    case scaleToFill
}

/// View that can handle images from a variety of sources
public struct SourcedImageView<LoadingContent, EmptyContent, ErrorContent>: View where LoadingContent: View, EmptyContent: View, ErrorContent: View {
    @ObservedObject var viewModel: SourcedImageViewModel
    private let imageScaling: SourcedImageScaling
    private let loadingContent: () -> LoadingContent
    private let emptyContent: () -> EmptyContent
    private let errorContent: (Error) -> ErrorContent
    
    @State private var imageState: SourcedImageViewModel.ImageState = .empty
    
    /// Initializes a new `SourcedImageView`
    ///
    /// - Parameters:
    ///   - viewModel: `ViewModel` that handles images from all sources
    ///   - imageScaling: Determines the scaling of the image
    ///   - loadingContent: `ViewBuilder` that creates the view that displays when/if the image is loading
    ///   - emptyContent: `ViewBuilder` that creates the view that displays when the sourced image cannot be loaded
    ///   - errorContent: `ViewBuilder` that creates the view that displays when fetching the sourced image errors
    public init(
        viewModel: SourcedImageViewModel,
        imageScaling: SourcedImageScaling = .scaleToFit,
        @ViewBuilder loadingContent: @escaping () -> LoadingContent,
        @ViewBuilder emptyContent: @escaping () -> EmptyContent,
        @ViewBuilder errorContent: @escaping (Error) -> ErrorContent
    ) {
        self.viewModel = viewModel
        self.imageScaling = imageScaling
        self.loadingContent = loadingContent
        self.emptyContent = emptyContent
        self.errorContent = errorContent
    }
    
    public var body: some View {
        makeBody()
            .onAppear {
                self.viewModel.markReady()
            }
            .onReceive(self.viewModel.imageState.receive(on: RunLoop.main)) { imageState in
                self.imageState = imageState
            }
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        switch self.imageState {
        case .error(let error):
            self.errorContent(error)
        case .loaded(let uiImage):
            switch self.imageScaling {
            case .scaleToFit:
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            case .scaleToFill:
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
        case .loading:
            self.loadingContent()
        case .systemImage(let name):
            switch self.imageScaling {
            case .scaleToFit:
                Image(systemName: name)
                    .resizable()
                    .scaledToFit()
            case .scaleToFill:
                Image(systemName: name)
                    .resizable()
                    .scaledToFill()
            }
        case .empty:
            self.emptyContent()
        }
    }
}

extension SourcedImageView {
    /// Initializes a new `SourcedImageView` where `loadingContent` displays the default `ProgressView`
    ///
    /// - Parameters:
    ///   - viewModel: `ViewModel` that handles images from all sources
    ///   - imageScaling: Determines the scaling of the image
    public init(
        viewModel: SourcedImageViewModel,
        imageScaling: SourcedImageScaling = .scaleToFit
    ) where LoadingContent == DefaultProgressView, EmptyContent == Color, ErrorContent == Color {
        self.init(
            viewModel: viewModel,
            imageScaling: imageScaling,
            loadingContent: { DefaultProgressView() },
            emptyContent: { Color.clear },
            errorContent: { _ in Color.clear })
    }

    /// Initializes a new `SourcedImageView` where `loadingContent` displays the default `ProgressView`
    ///
    /// - Parameters:
    ///   - viewModel: `ViewModel` that handles images from all sources
    ///   - imageScaling: Determines the scaling of the image
    ///   - errorContent: `ViewBuilder` that creates the view that displays when fetching the sourced image errors
    public init(
        viewModel: SourcedImageViewModel,
        imageScaling: SourcedImageScaling = .scaleToFit,
        @ViewBuilder errorContent: @escaping (Error) -> ErrorContent
    ) where LoadingContent == DefaultProgressView, EmptyContent == Color {
        self.init(
            viewModel: viewModel,
            imageScaling: imageScaling,
            loadingContent: { DefaultProgressView() },
            emptyContent: { Color.clear },
            errorContent: errorContent)
    }

    /// Initializes a new `SourcedImageView` where `loadingContent` displays the default `ProgressView`
    ///
    /// - Parameters:
    ///   - viewModel: `ViewModel` that handles images from all sources
    ///   - imageScaling: Determines the scaling of the image
    ///   - emptyContent: `ViewBuilder` that creates the view that displays when the sourced image cannot be loaded
    public init(
        viewModel: SourcedImageViewModel,
        imageScaling: SourcedImageScaling = .scaleToFit,
        @ViewBuilder emptyContent: @escaping () -> EmptyContent
    ) where LoadingContent == DefaultProgressView, ErrorContent == Color {
        self.init(
            viewModel: viewModel,
            imageScaling: imageScaling,
            loadingContent: { DefaultProgressView() },
            emptyContent: emptyContent,
            errorContent: { _ in Color.clear })
    }

    /// Initializes a new `SourcedImageView`
    ///
    /// - Parameters:
    ///   - viewModel: `ViewModel` that handles images from all sources
    ///   - imageScaling: Determines the scaling of the image
    ///   - loadingContent: `ViewBuilder` that creates the view that displays when/if the image is loading
    public init(
        viewModel: SourcedImageViewModel,
        imageScaling: SourcedImageScaling = .scaleToFit,
        @ViewBuilder loadingContent: @escaping () -> LoadingContent
    ) where EmptyContent == Color, ErrorContent == Color {
        self.init(
            viewModel: viewModel,
            imageScaling: imageScaling,
            loadingContent: loadingContent,
            emptyContent: { Color.clear },
            errorContent: { _ in Color.clear })
    }

    /// Initializes a new `SourcedImageView`
    ///
    /// - Parameters:
    ///   - viewModel: `ViewModel` that handles images from all sources
    ///   - imageScaling: Determines the scaling of the image
    ///   - loadingContent: `ViewBuilder` that creates the view that displays when/if the image is loading
    ///   - errorContent: `ViewBuilder` that creates the view that displays when fetching the sourced image errors
    public init(
        viewModel: SourcedImageViewModel,
        imageScaling: SourcedImageScaling = .scaleToFit,
        @ViewBuilder loadingContent: @escaping () -> LoadingContent,
        @ViewBuilder errorContent: @escaping (Error) -> ErrorContent
    ) where EmptyContent == Color {
        self.init(
            viewModel: viewModel,
            imageScaling: imageScaling,
            loadingContent: loadingContent,
            emptyContent: { Color.clear },
            errorContent: errorContent)
    }

    /// Initializes a new `SourcedImageView`
    ///
    /// - Parameters:
    ///   - viewModel: `ViewModel` that handles images from all sources
    ///   - imageScaling: Determines the scaling of the image
    ///   - loadingContent: `ViewBuilder` that creates the view that displays when/if the image is loading
    ///   - emptyContent: `ViewBuilder` that creates the view that displays when the sourced image cannot be loaded
    public init(
        viewModel: SourcedImageViewModel,
        imageScaling: SourcedImageScaling = .scaleToFit,
        @ViewBuilder loadingContent: @escaping () -> LoadingContent,
        @ViewBuilder emptyContent: @escaping () -> EmptyContent
    ) where ErrorContent == Color {
        self.init(
            viewModel: viewModel,
            imageScaling: imageScaling,
            loadingContent: loadingContent,
            emptyContent: emptyContent,
            errorContent: { _ in Color.clear })
    }

    /// Initializes a new `SourcedImageView` where `loadingContent` displays the default `ProgressView`
    ///
    /// - Parameters:
    ///   - viewModel: `ViewModel` that handles images from all sources
    ///   - imageScaling: Determines the scaling of the image
    ///   - emptyContent: `ViewBuilder` that creates the view that displays when the sourced image cannot be loaded
    ///   - errorContent: `ViewBuilder` that creates the view that displays when fetching the sourced image errors
    public init(
        viewModel: SourcedImageViewModel,
        imageScaling: SourcedImageScaling = .scaleToFit,
        @ViewBuilder emptyContent: @escaping () -> EmptyContent,
        @ViewBuilder errorContent: @escaping (Error) -> ErrorContent
    ) where LoadingContent == DefaultProgressView {
        self.init(
            viewModel: viewModel,
            imageScaling: imageScaling,
            loadingContent: { DefaultProgressView() },
            emptyContent: emptyContent,
            errorContent: errorContent)
    }
}

/// A type erased `ProgressView` that fills all availablespace
public struct DefaultProgressView: View {
    public var body: some View {
        ZStack {
            Color.clear.zIndex(0.0)
            ProgressView().zIndex(1.0)
        }
        .background(.ultraThinMaterial)
    }
}
