// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MLXTranslate",
    platforms: [.macOS(.v14), .iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MLXTranslate",
            targets: ["MLXTranslate"]),
    ],
    dependencies: [
//        .package(url: "https://github.com/ml-explore/mlx-swift", .upToNextMinor(from: "0.21.2")),
        .package(url: "https://github.com/ml-explore/mlx-swift-examples/", branch: "main"),
//        .package(
//            url: "https://github.com/huggingface/swift-transformers", .upToNextMinor(from: "0.1.17")
//        ),
//        .package(
//            url: "https://github.com/apple/swift-async-algorithms", .upToNextMinor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MLXTranslate",
            dependencies: [
                .product(name: "MLXLLM", package: "mlx-swift-examples")
            ]),
        .testTarget(
            name: "MLXTranslateTests",
            dependencies: ["MLXTranslate"]
        ),
    ]
)
