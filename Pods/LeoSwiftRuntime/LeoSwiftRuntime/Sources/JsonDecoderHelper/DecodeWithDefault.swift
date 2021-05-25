//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

public extension KeyedDecodingContainerProtocol {
    /// Decodes a value of the given type for the given key and returns the decoded value. If the given key is not present default value will be returned.
    /// - Parameters:
    ///   - type: type of the value to be decoded.
    ///   - key: key of the value to be decoded.
    ///   - defaultValue: default value for the value to be decoded if key is not present.
    /// - Returns: Decoded value.
    func decodeWithDefault<T>(_ type: T.Type, forKey key: Self.Key, withDefault defaultValue: T) throws -> T where T: Decodable {
        let result = try decodeIfPresent(type, forKey: key)
        if let result = result {
            return result
        }
        return defaultValue
    }
}
