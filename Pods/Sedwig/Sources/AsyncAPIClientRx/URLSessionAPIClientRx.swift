//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation
import RxSwift

extension URLSessionAPIClient: AsyncAPIClientRx {
    public func sendRequestForTypedResponse(_ request: Request)
        -> Single<Result<Response, APIClientError>> {
        Single<Result<Response, APIClientError>>.create { [weak self] single in
            let networkTask = self?.sendRequest(request) { result in
                single(.success(result))
                return
            }
            return Disposables.create { networkTask?.cancel() }
        }
    }

    public func sendRequest(_ request: Request) -> Single<Response> {
        sendRequestForTypedResponse(request).map { result in
            switch result {
            case let .success(response):
                return response
            case let .failure(error):
                throw error
            }
        }
    }

    public func sendRxDownloadRequestForTypedResponse(
        _ request: Request, storeResourceAt resourceStorageLocation: URL
    ) -> Single<Result<Response, APIClientError>> {
        Single<Result<Response, APIClientError>>.create { [weak self] single in
            let networkDownloadTask = self?.sendDownloadRequest(
                request, storeResourceAt: resourceStorageLocation
            ) { result in
                single(.success(result))
                return
            }
            return Disposables.create { networkDownloadTask?.cancel() }
        }
    }

    public func sendRxDownloadRequest(
        _ request: Request, storeResourceAt resourceStorageLocation: URL
    ) -> Single<Response> {
        sendRxDownloadRequestForTypedResponse(request, storeResourceAt: resourceStorageLocation).map { result in
            switch result {
            case let .success(downloadResponse):
                return downloadResponse
            case let .failure(error):
                throw error
            }
        }
    }

    public func sendUploadRequestForTypedResponse(_ request: Request) -> Single<Result<Response, APIClientError>> {
        Single<Result<Response, APIClientError>>.create { [weak self] single in
            let networkUploadTask = self?.sendUploadRequest(request) { result in
                single(.success(result))
                return
            }
            return Disposables.create { networkUploadTask?.cancel() }
        }
    }

    public func sendUploadRequest(_ request: Request) -> Single<Response> {
        sendUploadRequestForTypedResponse(request).map { result in
            switch result {
            case let .success(uploadResponse):
                return uploadResponse
            case let .failure(error):
                throw error
            }
        }
    }
}
