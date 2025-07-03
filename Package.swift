// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UpinnSecretsiOSLib",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UpinnSecretsiOSLib",
            targets: ["UpinnSecretsiOSLib"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .binaryTarget(
            name: "secretsFFI",
            path: "Sources/UpinnSecretsiOSLib/upinn_secretsFFI.xcframework"
        ),
        .target(
            name: "UpinnSecretsiOSLib",
            dependencies: ["secretsFFI"],
            path: "Sources/UpinnSecretsiOSLib",
            sources: ["UpinnSecretsiOSLib.swift"],
            publicHeadersPath: "include",
        ),
        .testTarget(
            name: "UpinnSecretsiOSLibTests",
            dependencies: ["UpinnSecretsiOSLib"]
        ),
    ]
)
