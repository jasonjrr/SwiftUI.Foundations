//
//  SDUIScreenViewDescription.swift
//
//
//  Created by Jason Lew-Rapai on 4/22/24.
//

import Foundation

extension SDUI {
    public struct ScreenViewDescription: Identifiable, Codable {
        public let id: UUID
        public let name: String
        public let factoryName: String
        public let contentViewDescription: SDUI.ViewDescription
        public let navigationBar: NavigationBarDescription?
        
        public init(
            name: String,
            factoryName: String,
            contentViewDescription: SDUI.ViewDescription,
            navigationBar: NavigationBarDescription?
        ) {
            self.id = UUID()
            self.name = name
            self.factoryName = factoryName
            self.contentViewDescription = contentViewDescription
            self.navigationBar = navigationBar
        }
    }
}

extension SDUI.ScreenViewDescription {
    public struct NavigationBarDescription: Identifiable, Codable {
        public let id: UUID
        public let title: String?
        public let leftBarAction1: NavigationBarAction?
        public let leftBarAction2: NavigationBarAction?
        public let rightBarAction1: NavigationBarAction?
        public let rightBarAction2: NavigationBarAction?
        
        public init(
            title: String?,
            leftBarAction1: NavigationBarAction? = nil,
            leftBarAction2: NavigationBarAction? = nil,
            rightBarAction1: NavigationBarAction? = nil,
            rightBarAction2: NavigationBarAction? = nil
        ) {
            self.id = UUID()
            self.title = title
            self.leftBarAction1 = leftBarAction1
            self.leftBarAction2 = leftBarAction2
            self.rightBarAction1 = rightBarAction1
            self.rightBarAction2 = rightBarAction2
        }
        
        public static func navigationBar(
            title: String?,
            leftBarAction1: NavigationBarAction? = nil,
            leftBarAction2: NavigationBarAction? = nil,
            rightBarAction1: NavigationBarAction? = nil,
            rightBarAction2: NavigationBarAction? = nil) -> NavigationBarDescription {
                NavigationBarDescription(title: title, leftBarAction1: leftBarAction1, leftBarAction2: leftBarAction2, rightBarAction1: rightBarAction1, rightBarAction2: rightBarAction2)
            }
    }
    
    public struct NavigationBarAction: Identifiable, Codable {
        public let id: UUID
        public let eventIdentifier: String
        public let text: String?
        public let imageURL: String?
        public let imageName: String?
        public let imageSystemName: String?
        
        public init(
            eventIdentifier: String,
            text: String? = nil,
            imageURL: String? = nil,
            imageName: String? = nil,
            imageSystemName: String? = nil
        ) {
            self.id = UUID()
            self.eventIdentifier = eventIdentifier
            self.text = text
            self.imageURL = imageURL
            self.imageName = imageName
            self.imageSystemName = imageSystemName
        }
        
        public static func action(eventIdentifier: String, text: String? = nil, image: Image? = nil) -> NavigationBarAction {
            let imageURL: String?
            let imageName: String?
            let imageSystemName: String?
            
            switch image {
            case .none:
                imageURL = nil
                imageName = nil
                imageSystemName = nil
            case .url(let urlString):
                imageURL = urlString
                imageName = nil
                imageSystemName = nil
            case .name(let name):
                imageURL = nil
                imageName = name
                imageSystemName = nil
            case .systemName(let systemName):
                imageURL = nil
                imageName = nil
                imageSystemName = systemName
            }
            
            return NavigationBarAction(eventIdentifier: eventIdentifier, text: text, imageURL: imageURL, imageName: imageName, imageSystemName: imageSystemName)
        }
    }
}

extension SDUI.ScreenViewDescription.NavigationBarAction {
    public enum Image {
        case url(String)
        case name(String)
        case systemName(String)
    }
}
