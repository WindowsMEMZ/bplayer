// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BPlayer",
    platforms: [
        .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BPlayer",
            targets: ["BPlayer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", exact: "5.5.0"),
        .package(url: "https://github.com/hyperoslo/Cache", from: "6.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf", from: "1.25.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "BPlayer",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "Cache", package: "Cache")
            ]
        ),
    ]
)
