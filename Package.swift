// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "CryptoStarterPack",
    products: [
        .library(
            name: "CryptoStarterPack",
            targets: ["CryptoStarterPack"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pumperknickle/Bedrock.git", from: "0.0.1"),
        .package(url: "https://github.com/vapor/crypto.git", from: "3.3.2"),
        .package(url: "https://github.com/Quick/Quick.git", from: "2.1.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.2"),
    ],
    targets: [
        .target(
            name: "CryptoStarterPack",
            dependencies: ["Crypto", "Bedrock"]),
        .testTarget(
            name: "CryptoStarterPackTests",
            dependencies: ["CryptoStarterPack", "Quick", "Nimble", "Bedrock"]),
    ]
)
