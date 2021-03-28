// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dumpling",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9),
    ],
    products: [        
        .library(
            name: "Dumpling",
            targets: ["Dumpling"]
        )
    ],
    targets: [
        .target(
            name: "Dumpling",
            path: "Sources",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "DumplingTests", 
            dependencies: ["Dumpling"], 
            path: "Tests",
            exclude: ["Info.plist"]
        )
    ]
)
