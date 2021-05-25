//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

// Our networking APIs use `URLSession` to do all the networking.
// A `URLSessionTask` requires `URLRequest`. If we fail to build `URLRequest`
// from `Request`, we won't be able to create `URLSessionTask`. Since our `APIs`
// are designed to return some kind of a `NetworkTask`, we return a`FailedNetworkTask`.
class FailedNetworkTask<NetworkResponse>: NetworkTask {
    private let notifyOnResume: (Result<NetworkResponse, APIClientError>) -> Void
    private let reason: APIClientError

    init(
        reason: APIClientError,
        notifyOnResume: @escaping (Result<NetworkResponse, APIClientError>) -> Void
    ) {
        self.notifyOnResume = notifyOnResume
        self.reason = reason
    }

    func resume() {
        notifyOnResume(.failure(reason))
    }

    func cancel() {
        // No-op
        // This method is only required because of conformance to NetworkDataTask.
        // It will never execute.
    }
}
