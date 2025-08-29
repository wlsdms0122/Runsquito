// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Runsquito",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13)
    ],
    products: [
        .library(
            name: "Runsquito",
            targets: ["Runsquito"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Runsquito",
            dependencies: []
        ),
        .testTarget(
            name: "RunsquitoTests",
            dependencies: [
                "Runsquito"
            ]
        )
    ]
)
