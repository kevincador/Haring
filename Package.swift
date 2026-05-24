// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Haring",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Haring",
            targets: ["Haring"]
        )
    ],
    targets: [
        .target(
            name: "Haring",
            path: "Haring/Classes"
        )
    ],
    swiftLanguageVersions: [.v5]
)
