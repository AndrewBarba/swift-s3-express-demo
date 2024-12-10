import AWSCloud

@main
struct S3ExpressDemo: AWSProject {
    func build() async throws -> Outputs {
        let httpAws = AWS.Function(
            "http-aws",
            targetName: "AppAWS",
            url: .enabled(cors: true)
        )

        let httpSoto = AWS.Function(
            "http-soto",
            targetName: "AppSoto",
            url: .enabled(cors: true)
        )

        let bucket = AWS.ExpressBucket("files").linkTo(httpAws, httpSoto)

        return [
            "httpAws": httpAws.url,
            "httpSoto": httpSoto.url,
            "bucket": bucket.hostname,
        ]
    }
}
