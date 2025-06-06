//
//  CallerMetadata.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/12/25.
//

import Foundation

public struct CallerMetadata: Sendable {
    public let fileID: String
    public let function: String
    public let line: Int
    public let column: Int
    public let timestamp: Date
    
    private let parentMetadataContainer: [CallerMetadata]?
    public var parentMetadata: CallerMetadata? {
        self.parentMetadataContainer?.first
    }
    
    /// https://stackoverflow.com/questions/24103376/is-there-a-way-to-get-line-number-and-function-name-in-swift-language
    public init(
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line,
        column: Int = #column,
        timestamp: Date = Date(),
        parentMetadata: CallerMetadata? = nil
    ) {
        self.fileID = fileID
        self.function = function
        self.line = line
        self.column = column
        self.timestamp = timestamp
        
        if let parentMetadata {
            self.parentMetadataContainer = [parentMetadata]
        } else {
            self.parentMetadataContainer = nil
        }
    }
    
    @inlinable
    public static func metadata(
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line,
        column: Int = #column,
        timestamp: Date = Date(),
        parentMetadata: CallerMetadata? = nil
    ) -> CallerMetadata {
        CallerMetadata(fileID: fileID, function: function, line: line, column: column, timestamp: timestamp, parentMetadata: parentMetadata)
    }
}
