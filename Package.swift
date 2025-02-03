// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIComponentExtensions",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UIComponentExtensions",
            targets: ["UIComponentExtensions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/lkzhao/UIComponent.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UIComponentExtensions",
            dependencies: [.product(name: "UIComponent", package: "UIComponent")]),

    ]
)
