//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Masks sensitive information in a log message.
public typealias LogMessageSanitizer = (_ unsanitizedMessage: String) -> String

/// Defines configuration for logging.
public struct LogConfiguration {
    /// Object responsible for logging operations.
    public let logger: Logger
    /// Specifies the log level for all components of a request except the body.
    public let requestMetadata: LogLevel
    /// Specifies the log level for a request body.
    public let requestBody: LogLevel
    /// Specifies the log level for all components of a response except the body.
    public let responseMetadata: LogLevel
    /// Specifies the log level for a response body.
    public let responseBody: LogLevel
    /// Masks sensitive information in a log message.
    public let messageSanitizer: LogMessageSanitizer

    /// Instantiates `LogConfiguration`. Any property that speciefies the `LogLevel`,
    /// if left unset, will be set to `LogLevel.none`.
    public init(
        logger: Logger = NoOpLogger(),
        requestMetadata: LogLevel = .none,
        requestBody: LogLevel = .none,
        responseMetadata: LogLevel = .none,
        responseBody: LogLevel = .none,
        messageSanitizer: @escaping LogMessageSanitizer = { unsanitizedMessage in
            unsanitizedMessage
        }
    ) {
        self.logger = logger
        self.requestMetadata = requestMetadata
        self.requestBody = requestBody
        self.responseMetadata = responseMetadata
        self.responseBody = responseBody
        self.messageSanitizer = messageSanitizer
    }
}
