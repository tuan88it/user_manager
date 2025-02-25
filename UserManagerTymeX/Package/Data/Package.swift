// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Data",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Data",
            targets: ["Data"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.8.0"),
        .package(path: "../Infrastructure"),
        .package(path: "../LocalStorage"),
        .package(path: "../Domain")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Data",
            dependencies: [
                "RxSwift",
                "Domain",
                "Infrastructure",
                "LocalStorage"
            ]
        ),
        .testTarget(
            name: "DataTests",
            dependencies: [
                "Data",
                .product(name: "RxTest", package: "RxSwift"),
                .product(name: "RxBlocking", package: "RxSwift")
            ]
        ),
    ]
)
