// swift-tools-version:5.3

import Foundation
import PackageDescription

let file = "WebRTC-101.4951.5.1.1/WebRTC.xcframework.zip"

let package = Package(
    name: "Sora",
    platforms: [.macOS(.v11)],
    products: [
        .library(name: "Sora", targets: ["Sora"]),
        .library(name: "WebRTC", targets: ["WebRTC"]),
    ],
    targets: [
        .binaryTarget(
            name: "WebRTC",
            url: "https://github.com/soudegesu/sora-macos-sdk-specs/releases/download/\(file)",
            checksum: "0bd023ccaaa30f12cb4ea478a5c403bc337fcf7118feed34a0eed37d2fe7646e"
        ),
        .target(
            name: "Sora",
            dependencies: ["WebRTC"],
            path: "Sora",
            exclude: ["Info.plist"],
            resources: []
        ),
    ]
)
