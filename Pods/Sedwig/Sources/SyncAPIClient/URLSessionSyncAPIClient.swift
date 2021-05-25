//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

extension URLSessionAPIClient: SyncAPIClient {
    public func send(request: Request) -> Result<Response, APIClientError> {
        var requestResult: Result<Response, APIClientError>?
        let semaphore = DispatchSemaphore(value: dispatchSemaphoreValue)
        _ = sendRequest(request) { result in
            requestResult = result
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: .distantFuture)
        return requestResult!
    }
}

private let dispatchSemaphoreValue: Int = 0
