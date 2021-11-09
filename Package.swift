// swift-tools-version:5.3

import PackageDescription
import Foundation

let file = "WebRTC-95.4638.2.2.2/WebRTC.xcframework.zip"

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
            checksum: "f480b0a0f494a308799baa18b960a8bfffe2b685f509c0f991b226fa341704ef"),
        .target(
            name: "Sora",
            dependencies: ["WebRTC", "Starscream"],
            path: "Sora",
            exclude: ["Info.plist"],
            resources: [])
    ]
)
