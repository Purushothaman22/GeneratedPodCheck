//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Enables networking calls.
protocol Networker {
    /// Prepares a networking task.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - onCompletion: A closure whose execution is guaranteed
    ///   except if `self` gets deinitialized.
    ///
    /// - Returns: `NetworkDataTask`.
    func networkDataTask(
        with request: Request,
        onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask

    /// Prepares a networking download task.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - resourceStorageLocation: Location where you store the downloaded resource.
    ///   - onCompletion: A closure whose execution is guaranteed
    ///   except if `self` gets deinitialized.
    ///
    /// - Returns: `NetworkDownloadTask`.
    func networkDownloadTask(
        with request: Request,
        and resourceStorageLocation: URL,
        onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask

    /// Prepares a networking upload task.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - onCompletion: A closure whose execution is guaranteed
    ///   except if `self` gets deinitialized.
    ///
    /// - Returns: `NetworkUploadTask`.
    func networkUploadTask(
        with request: Request,
        onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask
}
