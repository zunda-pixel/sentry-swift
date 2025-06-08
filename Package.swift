// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "sentry-swift",
  products: [
    .library(
      name: "Sentry",
      targets: ["Sentry"]
    ),
  ],
  targets: [
    .target(
      name: "Sentry"
    ),
    .testTarget(
      name: "SentryTests",
      dependencies: ["Sentry"]
    ),
  ]
)
