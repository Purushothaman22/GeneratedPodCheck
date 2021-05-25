//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

/// HTTP request method.
/// For more information,
/// see [MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods).
public enum HTTPMethod: String, Equatable {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case options = "OPTIONS"
    case head = "HEAD"
    case connect = "CONNECT"
    case trace = "TRACE"
    case patch = "PATCH"
}
