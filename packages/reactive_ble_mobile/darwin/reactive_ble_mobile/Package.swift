// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "reactive_ble_mobile",
    platforms: [
          .iOS("13.0"),
          .macOS("10.15")
    ],
    products: [
          .library(name: "reactive-ble-mobile", targets: ["reactive_ble_mobile"])
    ],
    dependencies: [
          .package(name: "FlutterFramework", path: "../FlutterFramework"),
          .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.0.0")
    ],
    targets: [
          .target(
              name: "reactive_ble_mobile",
              dependencies: [
                    .product(name: "FlutterFramework", package: "FlutterFramework"),
                    .product(name: "SwiftProtobuf", package: "swift-protobuf")
              ],
              resources: []
          )
    ]
)
