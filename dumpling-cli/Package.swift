// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "dumpling-cli",
    products: [
        .executable(name: "dumpling-cli", targets: ["dumpling-cli"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-argument-parser",
            .upToNextMinor(from: "0.4.0")
        ),
        .package(name: "Dumpling", path: "../")
    ],
    targets: [
        .target(
            name: "dumpling-cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "Dumpling"
            ]
        )
    ]
)
