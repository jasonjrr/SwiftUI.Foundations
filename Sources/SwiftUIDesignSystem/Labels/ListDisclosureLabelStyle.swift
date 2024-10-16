//
//  ListDisclosureLabelStyle.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

public struct ListDisclosureLabelStyle: LabelStyle {
    @Environment(Theme.self) var theme: Theme
    public var disclosureColor: Color?
    
    public init(disclosureColor: Color? = nil) {
        self.disclosureColor = disclosureColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            Spacer()
            configuration.icon
                .font(.subheadline)
                .foregroundColor(self.disclosureColor ?? self.theme.colors.separator.color)
        }
        .font(forStyle: .body)
    }
}

extension LabelStyle where Self == ListDisclosureLabelStyle {
    public static var listDisclosure: ListDisclosureLabelStyle {
        ListDisclosureLabelStyle()
    }
    
    public static func listDisclosure(disclosureColor: Color) -> ListDisclosureLabelStyle {
        ListDisclosureLabelStyle(disclosureColor: disclosureColor)
    }
}
