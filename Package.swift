// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIFoundations",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftUIFoundation",
            targets: ["SwiftUIFoundation"]),
        .library(
            name: "SwiftUIDesignSystem",
            targets: ["SwiftUIDesignSystem"]),
        .library(
            name: "SUIFBluetoothConnectivity",
            targets: ["SUIFBluetoothConnectivity"]),
        .library(
            name: "SUIFKeychain",
            targets: ["SUIFKeychain"]),
        .library(
            name: "SUIFNetworking",
            targets: ["SUIFNetworking"]),
        .library(
            name: "SUIFServerDrivenUI",
            targets: ["SUIFServerDrivenUI"]),
        .library(
            name: "SUIFTelemetry",
            targets: ["SUIFTelemetry"]),
        .library(
            name: "SUIFUserDefaults",
            targets: ["SUIFUserDefaults"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CombineCommunity/CombineExt.git", exact: Version(1, 8, 1)),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftUIFoundation",
            dependencies: [
                .product(name: "CombineExt", package: "CombineExt"),
            ]
        ),
        .target(
            name: "SwiftUIDesignSystem",
            dependencies: [
                .target(name: "SwiftUIFoundation"),
                .target(name: "SUIFNetworking"),
                .target(name: "SUIFTelemetry"),
                .product(name: "CombineExt", package: "CombineExt"),
            ]
        ),
        .target(
            name: "SUIFBluetoothConnectivity",
            dependencies: [
                .target(name: "SwiftUIFoundation"),
                .product(name: "CombineExt", package: "CombineExt"),
            ]
        ),
        .target(
            name: "SUIFKeychain",
            dependencies: [
                .target(name: "SwiftUIFoundation"),
                .product(name: "CombineExt", package: "CombineExt"),
            ]
        ),
        .target(
            name: "SUIFNetworking",
            dependencies: [
                .target(name: "SwiftUIFoundation"),
                .product(name: "CombineExt", package: "CombineExt"),
            ]
        ),
        .target(
            name: "SUIFServerDrivenUI",
            dependencies: [
                .target(name: "SwiftUIFoundation"),
                .product(name: "CombineExt", package: "CombineExt"),
            ]
        ),
        .target(
            name: "SUIFTelemetry",
            dependencies: [
                .target(name: "SwiftUIFoundation"),
                .product(name: "CombineExt", package: "CombineExt"),
            ]
        ),
        .target(
            name: "SUIFUserDefaults",
            dependencies: [
                .target(name: "SwiftUIFoundation"),
            ]
        ),
        .testTarget(
            name: "SwiftUIFoundationTests",
            dependencies: ["SwiftUIFoundation"]),
    ]
)
