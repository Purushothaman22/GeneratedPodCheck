//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Defines the structure of a HTTP response.
/// For more information,
/// see [MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/API/Response).
public struct Response: Equatable {
    private let lazyStringBodyMaintainer: LazyProvider<String>
    private let lazyCookiesMaintainer: LazyProvider<Cookies>
    public let statusCode: Int
    public let headers: Headers
    public let request: Request
    public static func == (lhs: Response, rhs: Response) -> Bool {
        if lhs.statusCode == rhs.statusCode,
            lhs.headers == rhs.headers,
            lhs.request == rhs.request,
            lhs.body == rhs.body {
            return true
        } else {
            return false
        }
    }

    public let body: Data?
    public lazy var stringBody: String? = lazyStringBodyMaintainer.getLazyParameter {
        guard let responseBody = self.body else {
            return nil
        }
        return String(decoding: responseBody, as: UTF8.self)
    }

    public lazy var cookies: Cookies? = lazyCookiesMaintainer.getLazyParameter {
        self.parseCookies()
    }

    init(
        statusCode: Int,
        headers: Headers,
        body: Data?,
        request: Request
    ) {
        self.statusCode = statusCode
        self.headers = headers
        self.request = request
        self.body = body
        lazyStringBodyMaintainer = LazyProvider<String>()
        lazyCookiesMaintainer = LazyProvider<Cookies>()
    }

    private func parseCookies() -> Cookies {
        guard let url = URL(string: request.path) else {
            return Cookies()
        }
        let headersDict = headers.all().reduce(into: [String: String]()) {
            $0[$1.value] = $1.name
        }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headersDict, for: url)
        var cookiesList: [Cookie] = []
        for cookie in cookies {
            cookiesList.append(
                Cookie(
                    name: cookie.name,
                    value: cookie.value,
                    domain: cookie.domain,
                    path: cookie.path,
                    expiresAt: cookie.expiresDate?.timeIntervalSince1970,
                    httpOnly: cookie.isHTTPOnly,
                    secure: cookie.isSecure
                )
            )
        }
        return Cookies(cookiesList)
    }
}
