# SwiftyALSA

<p>

  [![Swift Version Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCypherPoet%2FSwiftyALSA%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/CypherPoet/SwiftyALSA)

  [![Swift Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCypherPoet%2FSwiftyALSA%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/CypherPoet/SwiftyALSA)

</p>


<p>
    <img src="https://img.shields.io/badge/License-MIT-blue.svg" />
    <img src="https://github.com/CypherPoet/SwiftyALSA/workflows/Build%20&%20Test/badge.svg" />
    <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" />
    </a>
</p>


<p align="center">

_[ A brief synopsis of this library ]._

</p>


## Installation

### Xcode Projects

Xcode installation is not officialy supported, as this library is for linux only.

### Swift Package Manager Projects

You can add `SwiftyALSA` as a package dependency in your `Package.swift` file:

```swift
let package = Package(
    //...
    dependencies: [
        .package(
            url: "https://github.com/Vaidios/SwiftyALSA.git",
            branch: "master"
        ),
    ],
    //...
)
```

From there, refer to the `ALSA` "product" delivered by the `SwiftyALSA` "package" inside of any of your project's target dependencies:

```swift
targets: [
    .target(
        name: "YourLibrary",
        dependencies: [
            .product(
                name: "ALSA",
                package: "SwiftyALSA"
            ),
        ],
        ...
    ),
    ...
]
```

Then simply `import ALSA` wherever you’d like to use it.

## Usage

## 🗺 Roadmap

- World Domination

## 💻 Developing

### Requirements

- Xcode 14.0+

### ✍️ Building The Documentation

Documentation is built with [DocC](https://developer.apple.com/documentation/docc) (see [Apple's guidance for more details about creating DocC content](https://developer.apple.com/documentation/docc/api-reference-syntax)).

To build and preview the documentation output, follow the instructions for the [here](https://github.com/apple/swift-docc-plugin#previewing-documentation) for the `Swift-DocC Plugin`.

If you're using VSCode, there's also a [task configuration](./.vscode/tasks.json) that will handle this directly from the editor 💪

## 🏷 License

`SwiftyALSA` is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.