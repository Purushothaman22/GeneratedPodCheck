//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Defines configuration for `APIClient`.
public struct APIClientConfiguration {
    public let baseURL: String
    /// This property specifies how long (in seconds) a networking task
    /// can stay active before receiving a response.
    public let timeoutIntervalForRequest: TimeInterval
    /// This property specifies how long (in seconds) a request for a resource
    /// transfer can be active.
    public let timeoutIntervalForResource: TimeInterval
    /// This property is used to set default headers for all requests made using an instance of `APIClient`.
    public let defaultHeaders: Headers
    /// This property is used to set default query parameters for all requests made using an instance of `APIClient`.
    public let defaultQueryParameters: QueryParameters
    /// This property is used to specify configuration for logging.
    public let logConfiguration: LogConfiguration
    public init(
        baseURL: String = "",
        timeoutIntervalForRequest: TimeInterval = defaultRequestTimeoutInSeconds,
        timeoutIntervalForResource: TimeInterval = defaultResourceTimeoutInSeconds,
        defaultHeaders: Headers = Headers(),
        defaultQueryParameters: QueryParameters = QueryParameters(),
        logConfiguration: LogConfiguration = LogConfiguration()
    ) {
        self.baseURL = baseURL
        self.timeoutIntervalForRequest = timeoutIntervalForRequest
        self.timeoutIntervalForResource = timeoutIntervalForResource
        self.defaultHeaders = defaultHeaders
        self.defaultQueryParameters = defaultQueryParameters
        self.logConfiguration = logConfiguration
    }
}

public let defaultRequestTimeoutInSeconds: TimeInterval = 20.0
public let defaultResourceTimeoutInSeconds: TimeInterval = 20.0
