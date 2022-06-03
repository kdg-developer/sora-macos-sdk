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
            url: "https://github.com/kdg-developer/sora-macos-sdk-specs/releases/download/\(file)",
            checksum: "6804297e34fb5b5e88d1459c3eda492b6392c1782112cca023b117dd904985d2"
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
