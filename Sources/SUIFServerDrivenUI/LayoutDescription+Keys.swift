//
//  LayoutDescription+Keys.swift
//  
//
//  Created by Jason Lew-Rapai on 4/23/24.
//

import Foundation

extension SDUI.LayoutDescription {
    public enum Identifier: String {
        /// Maps to a SwiftUI `ScrollView` with its `axis` set to `.horizontal`
        case hScroll = "h-scroll"
        /// Maps to a SwiftUI `ScrollView` with its `axis` set to `.vertical`
        case vScroll = "v-scroll"
        /// Maps to a SwiftUI `HStack`
        case hStack = "h-stack"
        /// Maps to a SwiftUI `VStack`
        case vStack = "v-stack"
    }
    
    public enum PropertyKey: String {
        case alignmentKey = "alignment"
        case spacingKey = "spacing"
        
        public enum PaddingInsets: String {
            case top = "insets-top"
            case leading = "insets-leading"
            case bottom = "insets-bottom"
            case trailing = "insets-trailing"
        }
        public enum ContentInsets: String {
            case top = "content-insets-top"
            case leading = "content-insets-leading"
            case bottom = "content-insets-bottom"
            case trailing = "content-insets-trailing"
        }
    }
    
    public enum ValueKey {
        public enum HorizontalAlignmentKey: String {
            case center
            case leading
            case trailing
        }
        public enum VerticalAlignmentKey: String {
            case center
            case top
            case bottom
        }
    }
}
