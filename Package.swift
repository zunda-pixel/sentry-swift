// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "sentry-swift",
  platforms: [
    .macOS(.v13),
    .iOS(.v13),
    .watchOS(.v6),
    .tvOS(.v13),
    .visionOS(.v1),
    .macCatalyst(.v14),
  ],
  products: [
    .library(
      name: "Sentry",
      targets: ["Sentry"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/zunda-pixel/http-client.git", from: "0.3.1"),
    .package(url: "https://github.com/apple/swift-http-types.git", from: "1.4.0"),
    .package(url: "https://github.com/1024jp/GzipSwift.git", from: "6.1.0"),
  ],
  targets: [
    .target(
      name: "Sentry",
      dependencies: [
        .product(name: "HTTPClient", package: "http-client"),
        .product(name: "HTTPTypes", package: "swift-http-types"),
        .product(name: "HTTPTypesFoundation", package: "swift-http-types"),
        .product(name: "Gzip", package: "GzipSwift"),
      ]
    ),
    .testTarget(
      name: "SentryTests",
      dependencies: ["Sentry"],
      resources: [
        .process("Resources")
      ]
    ),
  ]
)
