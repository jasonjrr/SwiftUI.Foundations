//
//  SDUIScreenView.swift
//
//
//  Created by Jason Lew-Rapai on 4/22/24.
//

import SwiftUI

extension SDUI {
    public struct ScreenView<Content: View>: View {
        @Environment(\.eventManager) var eventManager: SDUI.EventManager

        private let screenViewDescription: SDUI.ScreenViewDescription
        private let accentColor: Color?
        private let content: (SDUI.ViewDescription) -> Content

        public init(screenViewDescription: SDUI.ScreenViewDescription, accentColor: Color?, @ViewBuilder content: @escaping (SDUI.ViewDescription) -> Content) {
            self.screenViewDescription = screenViewDescription
            self.accentColor = accentColor
            self.content = content
        }

        public var body: some View {
            makeBody()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if let action = self.screenViewDescription.navigationBar?.leftBarAction1 {
                            makeButton(action: action)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        if let action = self.screenViewDescription.navigationBar?.leftBarAction2 {
                            makeButton(action: action)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if let action = self.screenViewDescription.navigationBar?.rightBarAction1 {
                            makeButton(action: action)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if let action = self.screenViewDescription.navigationBar?.rightBarAction2 {
                            makeButton(action: action)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }

        @ViewBuilder
        private func makeBody() -> some View {
            if let title = self.screenViewDescription.navigationBar?.title {
                self.content(self.screenViewDescription.contentViewDescription)
                    .navigationTitle(title)
            } else {
                self.content(self.screenViewDescription.contentViewDescription)
            }
        }
        
        @ViewBuilder
        private func makeButton(action: SDUI.ScreenViewDescription.NavigationBarAction) -> some View {
            Button {
                self.eventManager.publishEvent(SDUI.EventManager.Event(identifier: action.eventIdentifier))
            } label: {
                if let text = action.text {
                    if (action.imageURL ?? action.imageName ?? action.imageSystemName) == nil {
                        Text(text)
                    } else {
                        Label {
                            Text(text)
                        } icon: {
                            makeImage(action: action)
                        }
                    }
                } else {
                    makeImage(action: action)
                }
            }
            .accentColor(self.accentColor)
        }
        
        @ViewBuilder
        private func makeImage(action: SDUI.ScreenViewDescription.NavigationBarAction) -> some View {
            if let urlString = action.imageURL {
                AsyncImage(url: URL(string: urlString))
            } else if let name = action.imageName {
                Image(name)
            } else if let systemName = action.imageSystemName {
                Image(systemName: systemName)
            }
        }
    }
}
