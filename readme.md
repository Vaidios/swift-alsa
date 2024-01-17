# ALSA wrapper for swift

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


This is a Swift package library that acts as a seamless and efficient wrapper around the ALSA (Advanced Linux Sound Architecture) library. It enables Swift developers to conveniently integrate audio functionality in their Linux-based applications by tapping into the power of ALSA.

## Key Features:

- **Sound Playback & Recording:** SwiftyALSA allows developers to integrate sound playback and recording functionalities into their applications, supporting various audio formats.
  
- **Hardware Configuration:** The library provides access to ALSA's hardware-level controls, allowing configuration of sound cards and other audio devices.
  
- **Intuitive Error Handling:** SwiftALSA translates ALSA's error codes into Swift-friendly error objects, simplifying the process of error handling for developers.

SwiftALSA is regularly updated to ensure compatibility with the most recent versions of Swift and ALSA. It is an open-source project and welcomes contributions from the Swift and ALSA developer communities.

**NOTE:** Utilizing SwiftALSA requires a basic understanding of ALSA's concepts and architecture, as it's essentially a Swift interface to the underlying ALSA library.


## Installation

### Xcode Projects

Xcode installation is not officialy supported, as this library is for linux only.

### Swift Package Manager Projects

You can add `swift-alsa` as a package dependency in your `Package.swift` file:

```swift
let package = Package(
    //...
    dependencies: [
        .package(
            url: "https://github.com/Vaidios/swift-alsa.git",
            branch: "main"
        ),
    ],
    //...
)
```

From there, refer to the `ALSA` "product" delivered by the `swift-alsa` "package" inside of any of your project's target dependencies:

```swift
targets: [
    .target(
        name: "YourLibrary",
        dependencies: [
            .product(
                name: "ALSA",
                package: "swift-alsa"
            ),
        ],
    ),
]
```

You also have to install an ALSA C library if not already available. Hopefully in the future, swift itself will prompt to install the library.
```bash
sudo apt update && sudo apt upgrade
sudo apt install libasound2-dev
```

Then simply `import ALSA` wherever you’d like to use it.

## Usage

## 🗺 Roadmap

- Extending available ALSA API's, contributions are very welcome!

## 💻 Developing

### Requirements

- Swift 5.8

## 🏷 License

`swift-alsa` is available under the MIT license. See the [LICENSE file](./LICENSE) for more info.