// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

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
    //    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", exact: "0.57.0"),
    .package(url: "https://github.com/DiscordBM/DiscordBM", exact: "1.13.3")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "DDBKit",
      dependencies: [
        "DiscordBM"
      ],
      exclude: ["ExtensionSupport/README.md"]
    ),
    .target(
      name: "Database",
      dependencies: [
        "DDBKit",
        "DiscordBM",
      ]
    ),
    .target(
      name: "DDBKitFoundation",
      dependencies: [
        "DDBKit",
        "Database",
        "DiscordBM",
        "DDBKitUtilities",
      ]
    ),
    .target(
      name: "DDBKitUtilities",
      dependencies: [
        "DDBKit",
        "DiscordBM",
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
    ),
  ]
)
