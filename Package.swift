// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
  name: "DDBKit",
  platforms: [
    .macOS(.v13),
    .iOS(.v16),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "DDBKit",
      targets: ["DDBKit"]
    ),
    .library(
      name: "DDBKitUtilities",
      targets: ["DDBKitUtilities"]
    ),
    .library(
      name: "DDBKitFoundation",
      targets: ["DDBKitFoundation"]
    ),
    .library(
      name: "Database",
      targets: ["Database"]
    ),
  ],
  dependencies: [
    // We only use exact version tags to ensure the package doesn't break with a minor update
    // since Discord sucks.
//    .package(url: "https://github.com/DiscordBM/DiscordBM", exact: "1.12.0"),
    
    /// temporary workaround to https://github.com/DiscordBM/DiscordBM/issues/78
    .package(url: "https://github.com/DiscordBM/DiscordBM", revision: "52fe13121d24dc9a250fec4fc969ccec06357961"),
    .package(url: "https://github.com/swift-server/async-http-client", from: "1.21.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "DDBKit",
      dependencies: [
        "DiscordBM",
        "Database",
        .product(name: "AsyncHTTPClient", package: "async-http-client"),
      ]
    ),
    .target(
      name: "Database",
      dependencies: [
        "DiscordBM",
        .product(name: "AsyncHTTPClient", package: "async-http-client"),
      ]
    ),
    .target(
      name: "DDBKitFoundation",
      dependencies: [
        "DDBKit",
        "DiscordBM",
        .product(name: "AsyncHTTPClient", package: "async-http-client"),
      ]
    ),
    .target(
      name: "DDBKitUtilities",
      dependencies: [
        "DDBKit",
        "DiscordBM",
        .product(name: "AsyncHTTPClient", package: "async-http-client"),
      ]
    ),
    .testTarget(
      name: "DDBKitTests",
      dependencies: [
        "DDBKit",
        "Database",
        "DDBKitUtilities",
        "DDBKitFoundation",
      ]
    )
  ]
)
