// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "ALSA")

package.products = [
  .library(name: "ALSA", targets: ["ALSA"])
]

package.providers = [.apt(["libasound2-dev"])]

package.dependencies = [
  .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")
]

package.targets = [
  
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
      ],
      resources: [
        .process("Assets")
      ]
    ),
  
    .systemLibrary(
      name: "CALSA",
      path: nil,
      pkgConfig: nil,
      providers: [.apt(["libasound2-dev"])]
    ),
  
    .testTarget(
      name: "ALSATests",
      dependencies: ["ALSA"]
    ),
]
