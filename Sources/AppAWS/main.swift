import AWSLambdaEvents
import AWSLambdaRuntime
@preconcurrency import AWSS3

let bucket = Lambda.env("BUCKET_FILES_NAME")!

let s3 = try await AWSS3.S3Client()

let runtime = LambdaRuntime { (event: APIGatewayV2Request, context: LambdaContext) -> APIGatewayV2Response in
    let session = try? await s3.createSession(input: .init(bucket: bucket))

    return APIGatewayV2Response(
        statusCode: .ok,
        body: "S3 Session: \(session?.credentials?.sessionToken ?? "(nil)")"
    )
}

try await runtime.run()
