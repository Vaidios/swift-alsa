// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ALSA",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ALSA",
            targets: ["ALSA"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ALSA",
            dependencies: [
                "CALSA"
            ]
        ),

        .executableTarget(
            name: "Example", 
            dependencies: [
                .target(name: "ALSA"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                ]
            ),

        .systemLibrary(
            name: "CALSA", 
            path: nil, 
            pkgConfig: nil, 
            providers: [.apt(["libasound2-dev"])]
        ),

        .testTarget(
            name: "ALSAWrapperTests",
            dependencies: ["ALSA"]),
    ]
)
