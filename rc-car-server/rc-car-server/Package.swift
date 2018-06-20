// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "rc-car-server",
    dependencies: [
        .Package(url: "https://github.com/vapor-community/sockets.git", majorVersion: 2),
        .Package(url: "https://github.com/uraimo/SwiftyGPIO.git", majorVersion: 1)
    ]
)
