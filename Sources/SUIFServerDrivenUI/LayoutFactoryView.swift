//
//  LayoutFactoryView.swift
//
//
//  Created by Jason Lew-Rapai on 4/22/24.
//

import SwiftUI
import SwiftUIFoundation

extension SDUI {
    /// Root-level Factory view for basic layout components such as Stacks and Scrolls.
    public struct LayoutFactoryView<Content: View>: View {
        /// Name of the factory
        public var name: String { SDUI.ViewDescription.layout.factoryName }
        
        /// Root `ViewDescription` that forms the foundation for the Factory
        public let viewDescription: SDUI.ViewDescription
        
        /// Closure that contains nested Factories to generate the final view.
        /// 
        /// - Parameters:
        ///   - viewDescription: The `ViewDescription` that defines the `View` to be returned.
        ///
        /// - Returns: A concrete `View` hierarchy described by the `ViewDescription`.
        @ViewBuilder
        public let factory: (SDUI.ViewDescription) -> Content
        
        public init(viewDescription: SDUI.ViewDescription, @ViewBuilder factory: @escaping (SDUI.ViewDescription) -> Content) {
            self.viewDescription = viewDescription
            self.factory = factory
        }
        
        public var body: some View {
            BodyView(viewDescription: self.viewDescription, factory: self.factory)
        }
    }
}

extension SDUI.LayoutFactoryView {
    internal struct BodyView<BodyContent: View>: View {
        @Environment(\.eventManager) private var eventManager
        
        let viewDescription: SDUI.ViewDescription
        @ViewBuilder
        let factory: (SDUI.ViewDescription) -> BodyContent
        
        init(viewDescription: SDUI.ViewDescription, @ViewBuilder factory: @escaping (SDUI.ViewDescription) -> BodyContent) {
            self.viewDescription = viewDescription
            self.factory = factory
        }
        
        var body: some View {
            let description = SDUI.LayoutDescription(viewDescription: self.viewDescription)
            switch description {
            case .vStack(let alignment, let spacing, let padding, let children):
                VStack(alignment: alignment, spacing: spacing) {
                    ContentView(children: children, factory: self.factory)
                }
                .padding(padding)
                
            case .hStack(let alignment, let spacing, let padding, let children):
                HStack(alignment: alignment, spacing: spacing) {
                    ContentView(children: children, factory: self.factory)
                }
                .padding(padding)
                
            case .vScroll(let alignment, let spacing, let padding, let contentInsets, let children):
                ScrollView(.vertical) {
                    VStack(alignment: alignment, spacing: spacing) {
                        ContentView(children: children, factory: self.factory)
                    }
                    .padding(contentInsets)
                }
                .padding(padding)
                
            case .hScroll(let alignment, let spacing, let padding, let contentInsets, let children):
                ScrollView(.horizontal) {
                    HStack(alignment: alignment, spacing: spacing) {
                        ContentView(children: children, factory: self.factory)
                    }
                    .padding(contentInsets)
                }
                .padding(padding)
                
            case .unknown(_, _, _):
                SDUI.UnknownViewDescriptionView(self.viewDescription)
            }
        }
    }
    
    struct ContentView<FactoryContent: View>: View {
        private let children: [SDUI.ViewDescription]
        @ViewBuilder
        private let factory: (SDUI.ViewDescription) -> FactoryContent
        
        init(children: [SDUI.ViewDescription], @ViewBuilder factory: @escaping (SDUI.ViewDescription) -> FactoryContent) {
            self.children = children
            self.factory = factory
        }
        
        var body: some View {
            ForEach(self.children) { child in
                if child.factoryName == SDUI.ViewDescription.layout.factoryName {
                    BodyView(viewDescription: child, factory: self.factory)
                } else {
                    self.factory(child)
                }
            }
        }
    }
}
