//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

func buildURLRequest(for request: Request) -> Result<URLRequest, APIClientError> {
    guard var components = URLComponents(string: request.path) else {
        return .failure(.badURL(request.path))
    }
    components.queryItems = request.queryParameters.map { parameter in
        URLQueryItem(name: parameter.name, value: parameter.value)
    }
    if let generatedURL = components.url {
        var urlRequest = URLRequest(url: generatedURL)
        urlRequest.httpMethod = request.method.rawValue
        for header in request.headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.name)
        }
        if let requestBodySource = request.bodySource {
            switch requestBodySource {
            case let .inMemory(body):
                urlRequest.httpBody = body
            case .onDisk:
                // When we make a request to upload a file directly from disk, the
                // `uploadTask` API provided in `Foundation` directly loads that file.
                // Hence, we have a no-op here.
                break
            }
        } else {
            urlRequest.httpBody = nil
        }
        return .success(urlRequest)
    } else {
        return .failure(.badURL(nil))
    }
}

func buildResponse(
    with data: Data?,
    _ request: Request,
    and httpResponse: HTTPURLResponse
) -> Result<Response, APIClientError> {
    guard let headers = Headers(httpResponse.allHeaderFields) else {
        return .failure(
            .badResponse(
                request: request,
                error: APIClientInternalError.badHTTPResponse(httpResponse)
            )
        )
    }
    return .success(
        Response(
            statusCode: httpResponse.statusCode,
            headers: headers,
            body: data,
            request: request
        )
    )
}
