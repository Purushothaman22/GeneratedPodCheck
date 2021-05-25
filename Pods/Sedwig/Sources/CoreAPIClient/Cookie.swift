//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Defines the structure of a HTTP cookie.
/// For more information,
/// see [MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies).
public struct Cookie: Equatable {
    public var name: String
    public var value: String
    public var domain: String?
    public var path: String?
    /// Optional expiry date; represented as the number of seconds since 1st January 1970.
    public var expiresAt: TimeInterval?
    public var httpOnly: Bool
    public var secure: Bool

    init(
        name: String,
        value: String,
        domain: String? = nil,
        path: String? = nil,
        expiresAt: TimeInterval? = nil,
        httpOnly: Bool = true,
        secure: Bool = false
    ) {
        self.name = name
        self.value = value
        self.domain = domain
        self.path = path
        self.expiresAt = expiresAt
        self.httpOnly = httpOnly
        self.secure = secure
    }
}
