//
//  File.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 4/8/25.
//

import Foundation

public struct Version: Codable, Comparable, CustomStringConvertible, Sendable {
    public let major: Int
    public let minor: Int?
    public let patch: Int?
    public let build: Int?
    
    public var description: String {
        var out: String = "\(self.major).\(self.minor ?? 0).\(self.patch ?? 0)"
        if let build = self.build {
            out += " (\(build))"
        }
        return out
    }
    
    public init(major: Int, minor: Int? = nil, patch: Int? = nil, build: Int? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.build = build
    }
    
    public init?(_ versionString: String) {
        let splits = versionString.split(separator: ".")
        if splits.isEmpty {
            return nil
        }
        if splits.count < 3 {
            let majorSlice = splits.dropLast(splits.count - 1)
            if let major = Int(String(majorSlice[0])) {
                self.major = major
            } else {
                return nil
            }
            if splits.isEmpty {
                self.minor = nil
                self.patch = nil
                self.build = nil
                return
            } else if let minor = Int(String(splits[0])) {
                self.minor = minor
                self.patch = nil
                self.build = nil
            } else {
                return nil
            }
        } else if splits.count == 3 {
            if let major = Int(String(splits[0])),
               let minor = Int(String(splits[1])) {
                self.major = major
                self.minor = minor
            } else {
                return nil
            }
            let patchAndBuild = splits[2].split(separator: "(")
            if patchAndBuild.isEmpty {
                self.patch = nil
                self.build = nil
            } else if patchAndBuild.count == 2,
                let patch = Int(String(patchAndBuild[0].trimmingCharacters(in: .whitespaces))),
                let build = Int(String(patchAndBuild[1].trimmingCharacters(in: [")"]))) {
                self.patch = patch
                self.build = build
            } else if patchAndBuild.count == 1,
                let patch = Int(String(patchAndBuild[0].trimmingCharacters(in: .whitespaces))) {
                self.patch = patch
                self.build = nil
            }
            else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }
        if lhs.minor != rhs.minor {
            return lhs.minor ?? 0 < rhs.minor ?? 0
        }
        if lhs.patch != rhs.patch {
            return lhs.patch ?? 0 < rhs.patch ?? 0
        }
        return lhs.build ?? 0 < rhs.build ?? 0
    }
    
    public static func <= (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }
        if lhs.minor != rhs.minor {
            return lhs.minor ?? 0 < rhs.minor ?? 0
        }
        if lhs.patch != rhs.patch {
            return lhs.patch ?? 0 < rhs.patch ?? 0
        }
        return lhs.build ?? 0 <= rhs.build ?? 0
    }
}
