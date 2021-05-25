//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Defines the structure of a HTTP header.
/// For more information,
/// see [MDN Documentation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers).
public struct Header: Equatable {
    public let name: String
    public let value: String
}
