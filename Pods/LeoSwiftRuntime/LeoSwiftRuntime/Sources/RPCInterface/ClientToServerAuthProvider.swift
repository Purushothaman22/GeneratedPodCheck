//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// A auth token provider for client to server authentication.
///
/// Client to server authentication requires an auth token to be sent by the client to the server.
/// This interface requires implementations to securely store an auth token.
/// Note that it is the responsibility of the implementation to be thread-safe.

public protocol ClientToServerAuthProvider {
    /// Retrieves current auth token.
    ///
    /// - Returns: Current auth token.
    func getAuthToken() -> String

    /// Store the updated auth token.
    ///
    /// - Parameter value: Updated auth token.
    func setAuthToken(value: String)
}
