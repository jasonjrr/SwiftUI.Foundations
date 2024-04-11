//
//  CallerMetadata.swift
//  
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Telemetry {
    public struct CallerMetadata {
        public let file: String
        public let fileID: String
        public let filePath: String
        public let function: String
        public let line: Int
        public let column: Int
        
        /// https://stackoverflow.com/questions/24103376/is-there-a-way-to-get-line-number-and-function-name-in-swift-language
        public init(
            file: String = #file,
            fileID: String = #fileID,
            filePath: String = #filePath,
            function: String = #function,
            line: Int = #line,
            column: Int = #column
        ) {
            self.file = file
            self.fileID = fileID
            self.filePath = filePath
            self.function = function
            self.line = line
            self.column = column
        }
        
        @inlinable
        public static func metadata(
            file: String = #file,
            fileID: String = #fileID,
            filePath: String = #filePath,
            function: String = #function,
            line: Int = #line,
            column: Int = #column
        ) -> CallerMetadata {
            CallerMetadata(file: file, fileID: fileID, filePath: filePath, function: function, line: line, column: column)
        }
    }
}
