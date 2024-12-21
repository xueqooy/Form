// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Form",
    platforms: [
        .iOS(.v13), .tvOS(.v13)
    ],
    products: [
        .library(
            name: "Form",
            targets: ["Form"]
        ),
    ],
    targets: [
        .target(
            name: "Form"
        ),
        .testTarget(
            name: "FormTests",
            dependencies: ["Form"]
        ),
    ]
)
