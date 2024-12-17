// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "s3-express-demo",
    platforms: [
        .macOS(.v15)
    ],
    dependencies: [
        .package(url: "https://github.com/swift-cloud/swift-cloud", branch: "main"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime", branch: "main"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-events", branch: "main"),
        .package(url: "https://github.com/awslabs/aws-sdk-swift", branch: "main"),
        .package(url: "https://github.com/soto-project/soto", branch: "s3-express"),
    ],
    targets: [
        .executableTarget(
            name: "AppAWS",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "AWSS3", package: "aws-sdk-swift"),
            ]
        ),
        .executableTarget(
            name: "AppSoto",
            dependencies: [
                .product(name: "AWSLambdaRuntime", package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "SotoS3", package: "soto"),
            ]
        ),
        .executableTarget(
            name: "Infra",
            dependencies: [
                .product(name: "AWSCloud", package: "swift-cloud")
            ]
        ),
    ]
)
