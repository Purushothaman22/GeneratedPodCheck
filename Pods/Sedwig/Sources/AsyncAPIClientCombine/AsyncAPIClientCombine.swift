//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Combine
import Foundation
// This directive is in place since `Combine` is only supported from
// iOS - 13, macOS - 10.15, watchOS - 6, and tvOS - 13 onwards.
// It would have been ideal if we could specify platform dependencies
// at the product level. But since this is not feasible, we have this workaround.
// For more information on this,
// see https://forums.swift.org/t/platform-per-target/29253.
@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
public protocol AsyncAPIClientCombine {
    /// Makes an asynchronous HTTP request using `Combine`.
    /// The network request is cancelled without returning an error
    /// when subscription to publisher is cancelled, or when the object
    /// that holds the subscription gets deallocated.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    func sendRequest(_ request: Request)
        -> Publishers.HandleEvents<Future<Response, APIClientError>>

    /// Makes an asynchronous HTTP download request using `Combine`.
    /// The network request is cancelled without returning an error
    /// when subscription to publisher is cancelled, or when the object
    /// that holds the subscription gets deallocated.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - storeResourceAt: `URL` to which the downloaded resource must be saved.
    ///   The resource is moved to the specified `URL` only after all of the
    ///   contents are downloaded.
    func sendCombineDownloadRequest(_ request: Request, storeResourceAt resourceStorageLocation: URL)
        -> Publishers.HandleEvents<Future<Response, APIClientError>>

    /// Makes an asynchronous HTTP upload request using `Combine`.
    /// The network request is cancelled without returning an error
    /// when subscription to publisher is cancelled, or when the object
    /// that holds the subscription gets deallocated.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    func sendUploadRequest(_ request: Request)
        -> Publishers.HandleEvents<Future<Response, APIClientError>>
}
