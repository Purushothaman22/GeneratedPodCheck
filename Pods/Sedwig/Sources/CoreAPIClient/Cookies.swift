//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Maintains a list of cookies.
public struct Cookies {
    private let cookies: [Cookie]

    init(_ cookies: [Cookie] = []) {
        self.cookies = cookies
    }

    /// Returns the first cookie with the given name.
    ///
    /// - Parameters:
    ///   - name: Cookie name.
    public func first(named cookieName: String) -> Cookie? {
        for cookie in cookies where cookie.name == cookieName {
            return cookie
        }
        return nil
    }

    /// Returns value of the first cookie with the given name.
    ///
    /// - Parameters:
    ///   - name: Cookie name.
    public func firstValue(named cookieName: String) -> String? {
        first(named: cookieName)?.value
    }

    /// Returns list of cookies with the given name.
    ///
    /// - Parameters:
    ///   - name: Cookie name.
    public func all(named cookieName: String) -> [Cookie] {
        var cookiesList: [Cookie] = []
        for cookie in cookies where cookie.name == cookieName {
            cookiesList.append(cookie)
        }
        return cookiesList
    }

    /// Returns list of cookie values with the given cookie name.
    ///
    /// - Parameters:
    ///   - name: Cookie name.
    public func allValues(named cookieName: String) -> [String] {
        var cookieValuesList: [String] = []
        for cookie in cookies where cookie.name == cookieName {
            cookieValuesList.append(cookie.value)
        }
        return cookieValuesList
    }

    /// Returns list of all cookies.
    public func all() -> [Cookie] {
        cookies
    }

    /// Returns list of all cookie values.
    public func allValues() -> [String] {
        cookies.map { $0.value }
    }

    /// Returns list of all cookie names.
    public func allNames() -> [String] {
        cookies.map { $0.name }
    }
}

extension Cookies: Sequence {
    public func makeIterator() -> CookiesIterator {
        CookiesIterator(self)
    }
}

public struct CookiesIterator: IteratorProtocol {
    private let cookiesList: [Cookie]
    private var cookieListCurrentIndex: Int

    init(_ cookiesList: Cookies) {
        self.cookiesList = cookiesList.all()
        cookieListCurrentIndex = zero
    }

    /// Returns the next header in the headers list; nil if none exist.
    public mutating func next() -> Cookie? {
        guard cookieListCurrentIndex < cookiesList.count else {
            return nil
        }
        let nextCookieIndex = cookieListCurrentIndex
        cookieListCurrentIndex += 1
        return cookiesList[nextCookieIndex]
    }
}

private let zero: Int = 0
