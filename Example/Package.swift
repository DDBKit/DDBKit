// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ExampleBot",
  platforms: [
    .macOS(.v14)
  ],
  dependencies: [
    .package(url: "https://github.com/llsc12/PrivateFrameworks", branch: "main"),
    .package(path: "./../../DDBKit"),
//    .package(url: "https://github.com/llsc12/DDBKit", branch: "main")
    /// you'll want to use a version tag instead, use the below line
    /// `.package(url: "https://github.com/llsc12/DDBKit", from: "0.1.6")`
    /// i happen to also use this example project to test the package :3
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .executableTarget(
      name: "ExampleBot",
      dependencies: [
        .product(name: "Dictionary", package: "PrivateFrameworks"),
        .product(name: "Calculate", package: "PrivateFrameworks"),
        .product(name: "DDBKit", package: "DDBKit"),
        .product(name: "Database", package: "DDBKit"),
        .product(name: "DDBKitUtilities", package: "DDBKit"),
        .product(name: "DDBKitFoundation", package: "DDBKit"),
      ]
    ),
  ]
)
