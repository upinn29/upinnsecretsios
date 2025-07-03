// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UpinnSecretsiOS",
    platforms: [.iOS(.v15),],    
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UpinnSecretsiOS",
            targets: ["UpinnSecretsiOS"]),
    ],
    targets: [
        .binaryTarget(
            name: "UpinnSecrets",
            path: "Sources/UpinnSecretsiOS/lib/upinn_secretsFFI.xcframework"
        ),
        .target(
            name: "UpinnSecretsiOS",
            dependencies: ["UpinnSecrets"],
            path: "./Sources/UpinnSecretsiOS",
        ),
        .testTarget(
            name: "UpinnSecretsiOSTests",
            dependencies: ["UpinnSecretsiOS"]
        ),
    ]
)
