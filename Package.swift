// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "team-service",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .branch("beta")),
        .package(url: "https://github.com/vapor/mysql-driver.git", .branch("beta")),
        .package(url: "https://github.com/vapor/jwt.git", .branch("beta")),
        .package(url: "https://github.com/Skelpo/SkelpoMiddleware.git", .branch("vapor-3"))
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentMySQL", "JWT", "SkelpoMiddleware"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources",
                ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

