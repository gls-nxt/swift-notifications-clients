// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "AppFeature", targets: ["AppFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "0.9.0"),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation", from: "0.1.0"),
        // NotificationsClients library
        .package(path: "../..")
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
                .product(name: "NotificationsClients", package: "NotificationsClients"),
            ],
            resources: []
        ),
    ]
)
