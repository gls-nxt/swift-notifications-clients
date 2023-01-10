// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NotificationsClients",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "NotificationsClients",
            targets: ["RemoteNotificationsClient",
                      "UserNotificationsClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "0.8.0"),
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RemoteNotificationsClient",
            dependencies: [.product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")]),
        .target(
            name: "UserNotificationsClient",
            dependencies: [.product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay")]),
    ]
)
