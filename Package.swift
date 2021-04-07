// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CryptoStarterPack",
    platforms: [
        .iOS(.v12),
        .tvOS(.v12),
        .watchOS(.v5),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "CryptoStarterPack",
            targets: ["CryptoStarterPack"]),
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.2.0"),
        .package(url: "https://github.com/pumperknickle/Bedrock.git", from: "0.2.1"),
        .package(name: "Crypto", url: "https://github.com/vapor/crypto.git", from: "3.3.2"),
        .package(url: "https://github.com/Quick/Quick.git", from: "3.1.2"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "9.0.0"),
    ],
    targets: [
        .target(
            name: "CryptoStarterPack",
            dependencies: ["Crypto", "Bedrock", "CryptoSwift"]),
        .testTarget(
            name: "CryptoStarterPackTests",
            dependencies: ["CryptoStarterPack", "Quick", "Nimble", "Bedrock"]),
    ]
)
