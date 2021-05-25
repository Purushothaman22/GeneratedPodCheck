//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Maintains a list of headers.
public struct Headers: Equatable {
    private let headers: [Header]

    public init(_ headers: [Header] = []) {
        self.headers = headers
    }

    // Returns nil if an item of `headersDict` could not be broken into name and value, both of type `String`.
    init?(_ headersDict: [AnyHashable: Any]) {
        var headerList: [Header] = []
        for header in headersDict {
            if let name = header.key as? String, let value = header.value as? String {
                headerList.append(Header(name: name, value: value))
            } else {
                return nil
            }
        }
        headers = headerList
    }

    /// Returns the first header with the given name.
    ///
    /// - Parameters:
    ///   - name: Header name.
    public func first(named headerName: String) -> Header? {
        for header in headers where header.name == headerName {
            return header
        }
        return nil
    }

    /// Returns value of the first header with the given name.
    ///
    /// - Parameters:
    ///   - name: Header name.
    public func firstValue(named headerName: String) -> String? {
        first(named: headerName)?.value
    }

    /// Returns list of headers with the given name.
    ///
    /// - Parameters:
    ///   - name: Header name.
    public func all(named headerName: String) -> [Header] {
        var headersList: [Header] = []
        for header in headers where header.name == headerName {
            headersList.append(header)
        }
        return headersList
    }

    /// Returns list of header values with the given header name.
    ///
    /// - Parameters:
    ///   - name: Header name.
    public func allValues(named headerName: String) -> [String] {
        var headerValuesList: [String] = []
        for header in headers where header.name == headerName {
            headerValuesList.append(header.value)
        }
        return headerValuesList
    }

    /// Returns list of all headers.
    public func all() -> [Header] {
        headers
    }

    /// Returns list of all header values.
    public func allValues() -> [String] {
        headers.map { $0.value }
    }

    /// Returns list of all header names.
    public func allNames() -> [String] {
        headers.map { $0.name }
    }
}

extension Headers: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, String)...) {
        self = Headers(elements.map { Header(name: $0.0, value: $0.1) })
    }
}

extension Headers: Sequence {
    public func makeIterator() -> HeadersIterator {
        HeadersIterator(self)
    }
}

public struct HeadersIterator: IteratorProtocol {
    private let headersList: [Header]
    private var headerListCurrentIndex: Int

    init(_ headersList: Headers) {
        self.headersList = headersList.all()
        headerListCurrentIndex = zero
    }

    /// Returns the next header in the headers list; nil if none exist.
    public mutating func next() -> Header? {
        guard headerListCurrentIndex < headersList.count else {
            return nil
        }
        let nextHeaderIndex = headerListCurrentIndex
        headerListCurrentIndex += 1
        return headersList[nextHeaderIndex]
    }
}

private let zero: Int = 0
