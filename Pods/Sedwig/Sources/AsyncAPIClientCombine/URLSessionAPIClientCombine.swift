//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Combine
import Foundation

@available(iOS 13, macOS 10.15, watchOS 6, tvOS 13, *)
extension URLSessionAPIClient: AsyncAPIClientCombine {
    public func sendRequest(_ request: Request)
        -> Publishers.HandleEvents<Future<Response, APIClientError>> {
        var networkTask: NetworkTask?
        return Future<Response, APIClientError> { [weak self] resolve in
            networkTask = self?.sendRequest(request) { result in
                switch result {
                case let .success(response):
                    resolve(.success(response))
                case let .failure(error):
                    resolve(.failure(error))
                }
            }
        }.handleEvents(receiveCancel: {
            networkTask?.cancel()
        })
    }

    public func sendCombineDownloadRequest(
        _ request: Request, storeResourceAt resourceStorageLoacation: URL
    ) -> Publishers.HandleEvents<Future<Response, APIClientError>> {
        var networkDownloadTask: NetworkTask?
        return Future<Response, APIClientError> { [weak self] resolve in
            networkDownloadTask = self?.sendDownloadRequest(
                request, storeResourceAt: resourceStorageLoacation
            ) { result in
                switch result {
                case let .success(response):
                    resolve(.success(response))
                case let .failure(error):
                    resolve(.failure(error))
                }
            }
        }.handleEvents(receiveCancel: {
            networkDownloadTask?.cancel()
        })
    }

    public func sendUploadRequest(_ request: Request)
        -> Publishers.HandleEvents<Future<Response, APIClientError>> {
        var networkUploadTask: NetworkTask?
        return Future<Response, APIClientError> { [weak self] resolve in
            networkUploadTask = self?.sendUploadRequest(request) { result in
                switch result {
                case let .success(response):
                    resolve(.success(response))
                case let .failure(error):
                    resolve(.failure(error))
                }
            }
        }.handleEvents(receiveCancel: {
            networkUploadTask?.cancel()
        })
    }
}
