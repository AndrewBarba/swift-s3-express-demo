import AWSLambdaEvents
import AWSLambdaRuntime
import SotoS3

let bucket = Lambda.env("BUCKET_FILES_NAME")!

let aws = AWSClient()
let s3 = S3(client: aws)
let (s3ExpressClient, s3Express) = s3.createS3ExpressClientAndService(bucket: bucket)

let runtime = LambdaRuntime { (event: APIGatewayV2Request, context: LambdaContext) -> APIGatewayV2Response in
    do {
        _ = try await s3Express.putObject(
            body: .init(string: "Hello World!"),
            bucket: bucket,
            key: "test.\(Int.random(in: 0...10)).txt"
        )

        let doc = try await s3Express.getObject(
            bucket: bucket,
            key: "test.\(Int.random(in: 0...10)).txt"
        )

        let objects = try? await s3Express.listObjectsV2(bucket: bucket)

        return APIGatewayV2Response(
            statusCode: .ok,
            body:
                """
                ETag: \(doc.eTag ?? "No etag")
                Keys: \(objects?.keyCount ?? -1)
                """
        )
    } catch {
        return APIGatewayV2Response(
            statusCode: .internalServerError,
            body: error.localizedDescription
        )
    }
}

try await runtime.run()
try await s3ExpressClient.shutdown()
try await aws.shutdown()
