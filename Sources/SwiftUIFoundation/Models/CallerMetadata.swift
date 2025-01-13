//
//  CallerMetadata.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/12/25.
//


public struct CallerMetadata {
    public let fileID: String
    public let function: String
    public let line: Int
    public let column: Int
    
    /// https://stackoverflow.com/questions/24103376/is-there-a-way-to-get-line-number-and-function-name-in-swift-language
    public init(
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) {
        self.fileID = fileID
        self.function = function
        self.line = line
        self.column = column
    }
    
    @inlinable
    public static func metadata(
        fileID: String = #fileID,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) -> CallerMetadata {
        CallerMetadata(fileID: fileID, function: function, line: line, column: column)
    }
}
