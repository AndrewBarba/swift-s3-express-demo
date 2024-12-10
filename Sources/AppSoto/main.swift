import AWSLambdaEvents
import AWSLambdaRuntime
import SotoS3

let bucket = Lambda.env("BUCKET_FILES_NAME")!

let aws = AWSClient()
let s3 = S3(client: aws)

let runtime = LambdaRuntime { (event: APIGatewayV2Request, context: LambdaContext) -> APIGatewayV2Response in
    let session = try? await s3.createSession(bucket: bucket)

    return APIGatewayV2Response(
        statusCode: .ok,
        body: "S3 Session: \(session?.credentials.sessionToken ?? "(nil)")"
    )
}

try await runtime.run()
try await aws.shutdown()
