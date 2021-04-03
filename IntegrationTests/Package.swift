// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DumplingIntegrationTests",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v11),
    ],
    dependencies: [
        .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.1"),
        .package(name: "Dumpling", path: "../")
    ],
    targets: [
        .target(name: "Helpers", dependencies: []),
        .testTarget(
            name: "IntegrationTests",
            dependencies: ["SnapshotTesting", "Dumpling", "Helpers"],
            resources: [.process("Resources"), .copy("__Snapshots__")]
        )
    ]
)
