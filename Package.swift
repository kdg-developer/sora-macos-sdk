// swift-tools-version:5.3

import PackageDescription
import Foundation

let file = "WebRTC-97.4692.4.0.1/WebRTC.xcframework.zip"

let package = Package(
    name: "Sora",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "Sora", targets: ["Sora"]),
        .library(name: "WebRTC", targets: ["WebRTC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/daltoniam/Starscream.git", .exact( "4.0.4")),
    ],
    targets: [
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/soudegesu/sora-macos-sdk-specs/releases/download/\(file)",
            checksum: "ca9dbd420eaa80adad5167da97c208644fa0884e659a5442a8c1209ad4c8d4a4"),
        .target(
            name: "Sora",
            dependencies: ["WebRTC", "Starscream"],
            path: "Sora",
            exclude: ["Info.plist"],
            resources: [])
    ]
)
