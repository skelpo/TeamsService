// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "team-service",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/Skelpo/SkelpoMiddleware", from: "1.4.0"),
        .package(url: "https://github.com/Skelpo/JWTVapor", from: "0.9.0"),
        .package(url: "https://github.com/skelpo/JSON.git", from: "0.13.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentMySQL", "JWT", "SkelpoMiddleware", "JWTVapor", "JSON"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources",
                ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

