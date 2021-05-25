//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Defines the structure of a query parameter.
/// For more information,
/// see [MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/API/URL/searchParams).
public struct QueryParameter: Equatable {
    public var name: String
    public var value: String

    private mutating func set(value: String, for key: String) {
        name = key
        self.value = value
    }
}
