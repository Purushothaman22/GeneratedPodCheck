//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Stores a validated and normalized email id.
public struct EmailId: Codable, Equatable, Hashable {
    public var value: String

    public init(_ emailId: String) throws {
        guard emailId.contains("@") else {
            throw EmaildIdError.invalidEmaildId("Email Id \(emailId) is invalid.")
        }
        value = emailId.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

public enum EmaildIdError: Error {
    case invalidEmaildId(_ message: String)
}
