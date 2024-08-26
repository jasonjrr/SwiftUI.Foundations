//
//  LayoutDescription.swift
//  
//
//  Created by Jason Lew-Rapai on 4/23/24.
//

import SwiftUI

extension SDUI {
    /// `ViewDescription` mapping for `LayoutFactoryView` components.
    public enum LayoutDescription {
        /// The `ViewDescription` failed to map to a `LayoutDescription`.
        /// This could happen for any number of reasons and is included for debugging
        /// purposes.
        /// 
        /// - Parameters:
        ///   - identifier: Identifies which `View` is meant to be generated.
        ///   - properties: Values required to generate and customize the `View`.
        ///   - children: `ViewDescription`s for any `Views` that are meant to be in a parent-child relationship to the `View`.
        case unknown(identifier: String, properties: [String: String], children: [SDUI.ViewDescription])
        case vStack(alignment: HorizontalAlignment, spacing: Double, padding: EdgeInsets, children: [SDUI.ViewDescription])
        case hStack(alignment: VerticalAlignment, spacing: Double, padding: EdgeInsets, children: [SDUI.ViewDescription])
        case vScroll(alignment: HorizontalAlignment, spacing: Double, padding: EdgeInsets, contentInsets: EdgeInsets, children: [SDUI.ViewDescription])
        case hScroll(alignment: VerticalAlignment, spacing: Double, padding: EdgeInsets, contentInsets: EdgeInsets, children: [SDUI.ViewDescription])
        
        public init(viewDescription desc: SDUI.ViewDescription) {
            guard let identifier = SDUI.LayoutDescription.Identifier(rawValue: desc.identifier) else {
                self = .unknown(identifier: desc.identifier, properties: desc.properties, children: desc.children)
                return
            }
            
            switch identifier {
            case .vStack:
                self = .vStack(
                    alignment: Self.mapToHorizontalAlignment(desc.properties[SDUI.LayoutDescription.PropertyKey.alignmentKey.rawValue]),
                    spacing: Self.mapToDouble(desc.properties[SDUI.LayoutDescription.PropertyKey.spacingKey.rawValue]),
                    padding: Self.mapToPaddingInsets(desc.properties),
                    children: desc.children)
            case .hStack:
                self = .hStack(
                    alignment: Self.mapToVerticalAlignment(desc.properties[SDUI.LayoutDescription.PropertyKey.alignmentKey.rawValue]),
                    spacing: Self.mapToDouble(desc.properties[SDUI.LayoutDescription.PropertyKey.spacingKey.rawValue]),
                    padding: Self.mapToPaddingInsets(desc.properties),
                    children: desc.children)
            case .vScroll:
                self = .vScroll(
                    alignment: Self.mapToHorizontalAlignment(desc.properties[SDUI.LayoutDescription.PropertyKey.alignmentKey.rawValue]),
                    spacing: Self.mapToDouble(desc.properties[SDUI.LayoutDescription.PropertyKey.spacingKey.rawValue]),
                    padding: Self.mapToPaddingInsets(desc.properties),
                    contentInsets: Self.mapToContentInsets(desc.properties),
                    children: desc.children)
            case .hScroll:
                self = .hScroll(
                    alignment: Self.mapToVerticalAlignment(desc.properties[SDUI.LayoutDescription.PropertyKey.alignmentKey.rawValue]),
                    spacing: Self.mapToDouble(desc.properties[SDUI.LayoutDescription.PropertyKey.spacingKey.rawValue]),
                    padding: Self.mapToPaddingInsets(desc.properties),
                    contentInsets: Self.mapToContentInsets(desc.properties),
                    children: desc.children)
            }
        }
        
        private static func mapToHorizontalAlignment(_ value: String?) -> HorizontalAlignment {
            guard let value = SDUI.LayoutDescription.ValueKey.HorizontalAlignmentKey(rawValue: value ?? .empty) else {
                return .leading
            }
            switch value {
            case .center: return .center
            case .leading: return .leading
            case .trailing: return .trailing
            }
        }
        
        private static func mapToVerticalAlignment(_ value: String?) -> VerticalAlignment {
            switch value {
            case SDUI.LayoutDescription.ValueKey.VerticalAlignmentKey.center.rawValue: return .center
            case SDUI.LayoutDescription.ValueKey.VerticalAlignmentKey.top.rawValue: return .top
            case SDUI.LayoutDescription.ValueKey.VerticalAlignmentKey.bottom.rawValue: return .bottom
            default: return .center
            }
        }
        
        private static func mapToDouble(_ value: String?) -> Double {
            Double(value ?? .empty) ?? 0.0
        }
        
        private static func mapToPaddingInsets(_ properties: [String: String]) -> EdgeInsets {
            EdgeInsets(
                top: mapToDouble(properties[SDUI.LayoutDescription.PropertyKey.PaddingInsets.top.rawValue]),
                leading: mapToDouble(properties[SDUI.LayoutDescription.PropertyKey.PaddingInsets.leading.rawValue]),
                bottom: mapToDouble(properties[SDUI.LayoutDescription.PropertyKey.PaddingInsets.bottom.rawValue]),
                trailing: mapToDouble(properties[SDUI.LayoutDescription.PropertyKey.PaddingInsets.trailing.rawValue]))
        }
        
        private static func mapToContentInsets(_ properties: [String: String]) -> EdgeInsets {
            EdgeInsets(
                top: mapToDouble(properties[SDUI.LayoutDescription.PropertyKey.ContentInsets.top.rawValue]),
                leading: mapToDouble(properties[SDUI.LayoutDescription.PropertyKey.ContentInsets.leading.rawValue]),
                bottom: mapToDouble(properties[SDUI.LayoutDescription.PropertyKey.ContentInsets.bottom.rawValue]),
                trailing: mapToDouble(properties[SDUI.LayoutDescription.PropertyKey.ContentInsets.trailing.rawValue]))
        }
    }
}

extension SDUI.ViewDescription {
    public struct Layout {
        public let factoryName: String = "sdui.layout"
        
        public func vStack(alignment: String, spacing: Double, padding: EdgeInsets, children: [SDUI.ViewDescription]) -> SDUI.ViewDescription {
            SDUI.ViewDescription(
                factoryName: self.factoryName,
                identifier: SDUI.LayoutDescription.Identifier.vStack.rawValue,
                properties: [
                    SDUI.LayoutDescription.PropertyKey.alignmentKey.rawValue: alignment,
                    SDUI.LayoutDescription.PropertyKey.spacingKey.rawValue: String(spacing),
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.top.rawValue: "\(padding.top)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.leading.rawValue: "\(padding.leading)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.bottom.rawValue: "\(padding.bottom)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.trailing.rawValue: "\(padding.trailing)",
                ],
                children: children)
        }
        
        public func hStack(alignment: String, spacing: Double, padding: EdgeInsets, children: [SDUI.ViewDescription]) -> SDUI.ViewDescription {
            SDUI.ViewDescription(
                factoryName: self.factoryName,
                identifier: SDUI.LayoutDescription.Identifier.hStack.rawValue,
                properties: [
                    SDUI.LayoutDescription.PropertyKey.alignmentKey.rawValue: alignment,
                    SDUI.LayoutDescription.PropertyKey.spacingKey.rawValue: String(spacing),
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.top.rawValue: "\(padding.top)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.leading.rawValue: "\(padding.leading)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.bottom.rawValue: "\(padding.bottom)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.trailing.rawValue: "\(padding.trailing)",
                ],
                children: children)
        }
        
        public func vScroll(alignment: String, spacing: Double, padding: EdgeInsets, contentInsets: EdgeInsets, children: [SDUI.ViewDescription]) -> SDUI.ViewDescription {
            SDUI.ViewDescription(
                factoryName: self.factoryName,
                identifier: SDUI.LayoutDescription.Identifier.vScroll.rawValue,
                properties: [
                    SDUI.LayoutDescription.PropertyKey.alignmentKey.rawValue: alignment,
                    SDUI.LayoutDescription.PropertyKey.spacingKey.rawValue: String(spacing),
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.top.rawValue: "\(padding.top)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.leading.rawValue: "\(padding.leading)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.bottom.rawValue: "\(padding.bottom)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.trailing.rawValue: "\(padding.trailing)",
                    SDUI.LayoutDescription.PropertyKey.ContentInsets.top.rawValue: "\(contentInsets.top)",
                    SDUI.LayoutDescription.PropertyKey.ContentInsets.leading.rawValue: "\(contentInsets.leading)",
                    SDUI.LayoutDescription.PropertyKey.ContentInsets.bottom.rawValue: "\(contentInsets.bottom)",
                    SDUI.LayoutDescription.PropertyKey.ContentInsets.trailing.rawValue: "\(contentInsets.trailing)",
                ],
                children: children)
        }
        
        public func hScroll(alignment: String, spacing: Double, padding: EdgeInsets, contentInsets: EdgeInsets, children: [SDUI.ViewDescription]) -> SDUI.ViewDescription {
            SDUI.ViewDescription(
                factoryName: self.factoryName,
                identifier: SDUI.LayoutDescription.Identifier.hScroll.rawValue,
                properties: [
                    SDUI.LayoutDescription.PropertyKey.alignmentKey.rawValue: alignment,
                    SDUI.LayoutDescription.PropertyKey.spacingKey.rawValue: String(spacing),
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.top.rawValue: "\(padding.top)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.leading.rawValue: "\(padding.leading)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.bottom.rawValue: "\(padding.bottom)",
                    SDUI.LayoutDescription.PropertyKey.PaddingInsets.trailing.rawValue: "\(padding.trailing)",
                    SDUI.LayoutDescription.PropertyKey.ContentInsets.top.rawValue: "\(contentInsets.top)",
                    SDUI.LayoutDescription.PropertyKey.ContentInsets.leading.rawValue: "\(contentInsets.leading)",
                    SDUI.LayoutDescription.PropertyKey.ContentInsets.bottom.rawValue: "\(contentInsets.bottom)",
                    SDUI.LayoutDescription.PropertyKey.ContentInsets.trailing.rawValue: "\(contentInsets.trailing)",
                ],
                children: children)
        }
    }
    
    public static var layout: Layout {
        Layout()
    }
}
