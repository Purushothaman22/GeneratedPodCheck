//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Defines networking API errors.
public enum APIClientError: Error {
    /// An error condition representing an invalid `URL`.
    case badURL(String?)
    /// An error condition representing malformed response.
    case badResponse(request: Request, error: Error)
    /// An error condition where a resource couldn't be downloaded.
    case resourceDownloadFailed(request: Request, error: Error)
    /// An error condition representing invalid upload source.
    case invalidUploadSource
    /// An error condition representing no internet connection.
    case noInternet
    /// An error condition where connection times out.
    case connectionTimedOut
    /// An error condition where user cancels the request.
    case userCancelledRequest
    /// An error condition where the cause is unknown.
    case unexpectedError
}
