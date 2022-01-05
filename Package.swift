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
            checksum: "32bae6ccbda572ad608abc811d9422c75e6106ee0f8fb57009e8f427cc348a38"),
        .target(
            name: "Sora",
            dependencies: ["WebRTC", "Starscream"],
            path: "Sora",
            exclude: ["Info.plist"],
            resources: [])
    ]
)
