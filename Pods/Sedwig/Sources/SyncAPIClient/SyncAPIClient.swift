//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

public protocol SyncAPIClient {
    /// Makes a synchronous HTTP request.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///
    /// - Returns: `Result<Response, APIClientError>`.
    func send(request: Request) -> Result<Response, APIClientError>
}
