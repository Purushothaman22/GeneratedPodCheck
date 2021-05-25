//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

enum BodyInterpolationType {
    case request
    case response
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ request: Request) {
        let requestString = """
        Sending request:
        |URL: \(request.path)
        |Method: \(request.method)
        |Headers:
        |\(request.headers)
        |Query Parameters:
        |\(request.queryParameters)
        """
        appendLiteral(requestString)
    }

    mutating func appendInterpolation(_ response: Response) {
        let responseString = """
        Received response:
        |URL: \(response.request.path)
        |Status code: \(response.statusCode)
        |Headers:
        |\(response.headers)
        """
        appendLiteral(responseString)
    }

    mutating func appendInterpolation(
        stringBody: String?,
        url: String?,
        for bodyContainer: BodyInterpolationType
    ) {
        let logDataStringTitle: String
        logDataStringTitle = getLogTitle(for: bodyContainer)
        let logDataString: String
        if let dataString = stringBody {
            if dataString == "" {
                logDataString = """
                \(logDataStringTitle)
                |URL: \(url ?? "Empty")
                |Body could not be parsed as UTF-8 string
                |Content size: \(dataString.utf8.count) bytes
                """
            } else {
                logDataString = """
                \(logDataStringTitle)
                |URL: \(url ?? "Empty")
                |Body:
                |\(dataString)
                """
            }
        } else {
            logDataString = """
            \(logDataStringTitle)
            |URL: \(url ?? "Empty")
            |Body: "Empty"
            """
        }
        appendLiteral(logDataString)
    }

    mutating func appendInterpolation(forError error: APIClientError) {
        let errorDescription: String
        switch error {
        case let .badURL(url):
            errorDescription = "Request failed because of invalid URL: \(url ?? "Empty URL")"
        case let .badResponse(request, badResponseError):
            errorDescription =
                "Request at \(request.path) failed because of malformed response:  \(badResponseError)"
        case let .resourceDownloadFailed(request, error):
            errorDescription = "Download request at \(request.path) failed with error: \(error)"
        case .invalidUploadSource:
            errorDescription = "Upload source was invalid"
        case .connectionTimedOut:
            errorDescription = "Request timed out"
        case .noInternet:
            errorDescription = "Request failed because of no internet"
        case .userCancelledRequest:
            errorDescription = "User cancelled request"
        case .unexpectedError:
            errorDescription = "Request encountered unexpected error"
        }
        appendLiteral(errorDescription)
    }

    mutating func appendInterpolation(_ headers: Headers) {
        let headerStrings: [String] = getHeadersAsStrings(from: headers)
        appendLiteral(headerStrings.joined(separator: "\n"))
    }

    mutating func appendInterpolation(_ queryParameters: QueryParameters) {
        let paramStrings: [String] = getQueryParametersAsStrings(from: queryParameters)
        appendLiteral(paramStrings.joined(separator: "\n"))
    }

    private func getHeadersAsStrings(from headers: Headers) -> [String] {
        headers.all().map {
            "\($0.name): \($0.value)"
        }
    }

    private func getQueryParametersAsStrings(from params: QueryParameters) -> [String] {
        params.all().map {
            "\($0.name): \($0.value)"
        }
    }

    private func getLogTitle(for bodyContainer: BodyInterpolationType) -> String {
        switch bodyContainer {
        case .request:
            return "Request body:"
        case .response:
            return "Response body:"
        }
    }
}
