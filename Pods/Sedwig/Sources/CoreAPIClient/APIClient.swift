//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

public protocol APIClient {
    /// Makes an HTTP request.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - onResponse: A closure whose execution is guaranteed
    ///   (in case of getting a response or error), except if `self` gets deinitialized.
    func sendRequest(
        _ request: Request,
        _ onResponse: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask

    /// Makes an HTTP download request.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - storeResourceAt: `URL` to which the downloaded resource must be saved.
    ///   The resource is moved to the specified `URL` only after all of the
    ///   contents are downloaded.
    ///   - onDownloadResponse: A closure whose execution is guaranteed
    ///   (in case of getting a response or error), except if `self` gets deinitialized.
    func sendDownloadRequest(
        _ request: Request,
        storeResourceAt resourceStorageURL: URL,
        _ onResponse: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask

    /// Makes an HTTP upload request.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - onResponse: A closure whose execution is guaranteed
    ///   (in case of getting a response or error), except if `self` gets deinitialized.
    func sendUploadRequest(
        _ request: Request,
        _ onResponse: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask
}
