// swift-tools-version:5.3

import Foundation
import PackageDescription

let file = "WebRTC-101.4951.5.1.0/WebRTC.xcframework.zip"

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
            checksum: "8c2cb193c7390ee125508219f6470467a5395bcc68c88e556af44e89c9bf4683"
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
