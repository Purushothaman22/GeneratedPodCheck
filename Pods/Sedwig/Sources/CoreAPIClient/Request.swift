//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Defines the structure of a HTTP request.
/// For more information,
/// see [MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/API/Request).
public struct Request: Equatable {
    public let method: HTTPMethod
    public let path: String
    public let headers: Headers
    public let queryParameters: QueryParameters
    let bodySource: BodySource?
    public let socketTimeoutMS: Int?
    /// Optional connection timeout duration in milliseconds.
    public let connectionTimeoutMS: Int?
    public let omitDefaultHeaders: Bool
    public let omitDefaultQueryParameters: Bool

    /// Instantiates `Request`.
    /// Must be used when source of the body is in memory.
    public init(
        method: HTTPMethod,
        path: String,
        headers: Headers = Headers(),
        queryParameters: QueryParameters = QueryParameters(),
        cookies: Headers? = nil,
        body: Data? = nil,
        socketTimeoutMS: Int? = nil,
        connectionTimeoutMS: Int? = nil,
        omitDefaultHeaders: Bool = false,
        omitDefaultQueryParameters: Bool = false
    ) {
        self.method = method
        self.path = path
        var requestHeaders = headers.all()
        if let requestCookies = cookies {
            requestHeaders += requestCookies
        }
        self.headers = Headers(requestHeaders)
        self.queryParameters = queryParameters
        if let requestBody = body {
            bodySource = .inMemory(requestBody)
        } else {
            bodySource = nil
        }
        self.socketTimeoutMS = socketTimeoutMS
        self.connectionTimeoutMS = connectionTimeoutMS
        self.omitDefaultHeaders = omitDefaultHeaders
        self.omitDefaultQueryParameters = omitDefaultQueryParameters
    }

    /// Instantiates `Request`.
    /// Must be used when source of the body is on the disk.
    public init(
        method: HTTPMethod,
        path: String,
        headers: Headers = Headers(),
        queryParameters: QueryParameters = QueryParameters(),
        cookies: Headers? = nil,
        /// A location on the disk from which resource must be uploaded.
        uploadSourceLocation: URL,
        socketTimeoutMS: Int? = nil,
        connectionTimeoutMS: Int? = nil,
        omitDefaultHeaders: Bool = false,
        omitDefaultQueryParameters: Bool = false
    ) {
        self.method = method
        self.path = path
        var requestHeaders = headers.all()
        if let requestCookies = cookies {
            requestHeaders += requestCookies
        }
        self.headers = Headers(requestHeaders)
        self.queryParameters = queryParameters
        bodySource = .onDisk(uploadSourceLocation)
        self.socketTimeoutMS = socketTimeoutMS
        self.connectionTimeoutMS = connectionTimeoutMS
        self.omitDefaultHeaders = omitDefaultHeaders
        self.omitDefaultQueryParameters = omitDefaultQueryParameters
    }
}
