//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation
import RxSwift

public protocol AsyncAPIClientRx {
    /// Makes an asynchronous HTTP request using `RxSwift`.
    /// The network request is cancelled without returning an error
    /// when `Single` is disposed off.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    func sendRequest(_ request: Request) -> Single<Response>

    /// Makes an asynchronous HTTP request,
    /// returning a `Single` with typed error when request fails.
    /// The network request is cancelled without returning an error
    /// when `Single` is disposed off.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    func sendRequestForTypedResponse(_ request: Request) -> Single<Result<Response, APIClientError>>

    /// Makes an asynchronous HTTP download request using `RxSwift`.
    /// The network request is cancelled without returning an error
    /// when `Single` is disposed off.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - storeResourceAt: `URL` to which the downloaded resource must be saved.
    ///   The resource is moved to the specified `URL` only after all of the
    ///   contents are downloaded.
    func sendRxDownloadRequest(_ request: Request, storeResourceAt resourceStorageLocation: URL) -> Single<Response>

    /// Makes an asynchronous HTTP download request,
    /// returning a `Single` with typed error when request fails.
    /// The network request is cancelled without returning an error
    /// when `Single` is disposed off.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - storeResourceAt: `URL` to which the downloaded resource must be saved.
    ///   The resource is moved to the specified `URL` only after all of the
    ///   contents are downloaded.
    func sendRxDownloadRequestForTypedResponse(
        _ request: Request, storeResourceAt resourceStorageLocation: URL
    ) -> Single<Result<Response, APIClientError>>

    /// Makes an asynchronous HTTP upload request using `RxSwift`.
    /// The network request is cancelled without returning an error
    /// when `Single` is disposed off.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    func sendUploadRequest(_ request: Request) -> Single<Response>

    /// Makes an asynchronous HTTP upload request,
    /// returning a `Single` with typed error when request fails.
    /// The network request is cancelled without returning an error
    /// when `Single` is disposed off.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    func sendUploadRequestForTypedResponse(_ request: Request)
        -> Single<Result<Response, APIClientError>>
}
