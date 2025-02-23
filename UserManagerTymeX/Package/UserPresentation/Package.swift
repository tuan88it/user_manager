// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserPresentation",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UserPresentation",
            targets: ["UserPresentation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.8.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.2.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", from: "5.0.0"),
        .package(path: "../Domain"),
        .package(path: "../AppCommon"),
        .package(path: "../DependencyInjection")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UserPresentation",
            dependencies: [
                "RxSwift",
                "RxDataSources",
                .product(name: "RxRelay", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                "SnapKit",
                "Kingfisher",
                "RxDataSources",
                "Domain",
                "AppCommon",
                "DependencyInjection"
            ]
        ),
        .testTarget(
            name: "UserPresentationTests",
            dependencies: ["UserPresentation"]
        ),
    ]
)
