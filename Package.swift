// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DDBKit",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "DDBKit",
      targets: ["DDBKit"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/DiscordBM/DiscordBM", from: "1.10.0"),
    .package(url: "https://github.com/swift-server/async-http-client", from: "1.20.1"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "DDBKit",
      dependencies: [
        "DiscordBM",
        .product(name: "AsyncHTTPClient", package: "async-http-client")
      ]
    )
  ]
)
