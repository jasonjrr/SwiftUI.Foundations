//
//  UnknownViewDescriptionView.swift
//
//
//  Created by Jason Lew-Rapai on 4/22/24.
//

import SwiftUI

extension SDUI {
    public struct UnknownViewDescriptionView: View {
        @Environment(\.eventManager) var eventManager: SDUI.EventManager
        
        public let viewDescription: SDUI.ViewDescription
        
        public init(_ viewDescription: SDUI.ViewDescription) {
            self.viewDescription = viewDescription
        }
        
        public var body: some View {
            Color.clear.onAppear {
                print("!!! Unknown view description: \(self.viewDescription.identifier); props: \(self.viewDescription.properties); children: \(self.viewDescription.children)")
                self.eventManager.publishEvent(
                    withIdentifier: "sdui.unknown.view.description",
                    value: .error(SDUI.Errors.unknownViewDescription(self.viewDescription)))
            }
        }
    }
}
