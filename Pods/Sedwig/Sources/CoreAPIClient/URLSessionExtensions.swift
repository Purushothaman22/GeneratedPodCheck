//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

extension URLSession: Networker {
    func networkDataTask(
        with request: Request,
        onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        let result = buildURLRequest(for: request)
        switch result {
        case let .success(urlRequest):
            return execDataTaskOnURLRequestBuild(
                with: request,
                and: urlRequest,
                onCompletion
            )
        case let .failure(error):
            let networkTask = FailedNetworkTask(
                reason: error,
                notifyOnResume: onCompletion
            )
            return networkTask
        }
    }

    func networkDownloadTask(
        with request: Request,
        and resourceStorageLocation: URL,
        onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        let result = buildURLRequest(for: request)
        switch result {
        case let .success(urlRequest):
            return execDownloadTaskOnURLRequestBuild(
                with: request, resourceStorageLocation: resourceStorageLocation, and: urlRequest, onCompletion
            )
        case let .failure(error):
            let downloadTask = FailedNetworkTask(
                reason: error,
                notifyOnResume: onCompletion
            )
            return downloadTask
        }
    }

    func networkUploadTask(
        with request: Request,
        onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        let result = buildURLRequest(for: request)
        switch result {
        case let .success(urlRequest):
            return execUploadTaskOnURLRequestBuild(
                with: request, and: urlRequest, onCompletion
            )
        case let .failure(error):
            let networkTask = FailedNetworkTask(
                reason: error,
                notifyOnResume: onCompletion
            )
            return networkTask
        }
    }

    private func execDataTaskOnURLRequestBuild(
        with request: Request,
        and urlRequest: URLRequest,
        _ onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        let urlSessionDataTask: URLSessionDataTask =
            dataTask(with: urlRequest) { [weak self] data, urlResponse, error in
                // The error returned by `dataTask`, is always of type `NSError`?.
                // Hence, it is safe to check for `NSError` directly.
                if let nsError = error as NSError? {
                    guard let this = self else {
                        return
                    }
                    this.onNSError(with: request, and: nsError, onCompletion)
                } else if let httpResponse = urlResponse as? HTTPURLResponse {
                    let response = buildResponse(with: data, request, and: httpResponse)
                    onCompletion(response)
                } else {
                    onCompletion(
                        .failure(
                            .badResponse(
                                request: request,
                                error: APIClientInternalError.badHTTPResponse(urlResponse)
                            )
                        )
                    )
                }
            }
        return urlSessionDataTask
    }

    private func execDownloadTaskOnURLRequestBuild(
        with request: Request,
        resourceStorageLocation: URL,
        and urlRequest: URLRequest,
        _ onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        let urlSessionDownloadTask: URLSessionDownloadTask = downloadTask(
            with: urlRequest
        ) { [weak self] url, urlResponse, error in
            // The error returned by `downloadTask`, is always of type `NSError`?.
            // Hence, it is safe to check for `NSError` directly.
            if let nsError = error as NSError? {
                guard let this = self else {
                    return
                }
                this.onNSError(with: request, and: nsError, onCompletion)
            } else if let httpResponse = urlResponse as? HTTPURLResponse {
                let downloadResponse =
                    buildResponse(with: nil, request, and: httpResponse)
                switch downloadResponse {
                case let .success(downloadResponse):
                    if let downloadLocation = url {
                        let fileManager = FileManager()
                        do {
                            try fileManager.copyItem(
                                atPath: downloadLocation.path,
                                toPath: resourceStorageLocation.path
                            )
                            onCompletion(.success(downloadResponse))
                        } catch {
                            onCompletion(
                                .failure(
                                    .resourceDownloadFailed(request: request, error: error)
                                )
                            )
                        }
                    } else {
                        // This is a never occuring case since `downloadTask`
                        // returns either a `URL` or an `Error`.
                        fatalError()
                    }
                case let .failure(error):
                    onCompletion(.failure(error))
                }
            } else {
                onCompletion(
                    .failure(
                        .badResponse(
                            request: request,
                            error: APIClientInternalError.badHTTPResponse(urlResponse)
                        )
                    )
                )
            }
        }
        return urlSessionDownloadTask
    }

    private func execUploadTaskOnURLRequestBuild(
        with request: Request,
        and urlRequest: URLRequest,
        _ onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        if let requestBodySource = request.bodySource {
            switch requestBodySource {
            case let .inMemory(data):
                return uploadFromMemoryTask(
                    with: request, body: data, and: urlRequest, onCompletion
                )
            case let .onDisk(fileLocation):
                let fileManager = FileManager()
                if fileManager.fileExists(atPath: fileLocation.path) {
                    return uploadFromFileTask(
                        with: request, location: fileLocation, and: urlRequest, onCompletion
                    )
                } else {
                    let networkTask = FailedNetworkTask(
                        reason: .invalidUploadSource,
                        notifyOnResume: onCompletion
                    )
                    return networkTask
                }
            }
        } else {
            return FailedNetworkTask(
                reason: .invalidUploadSource,
                notifyOnResume: onCompletion
            )
        }
    }

    private func uploadFromFileTask(
        with request: Request,
        location uploadResourceLocation: URL,
        and urlRequest: URLRequest,
        _ onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        let urlSessionUploadTask: URLSessionUploadTask = uploadTask(
            with: urlRequest,
            fromFile: uploadResourceLocation
        ) { [weak self] data, urlResponse, error in
            // The error returned by `uploadTask`, is always of type `NSError`?.
            // Hence, it is safe to check for `NSError` directly.
            if let nsError = error as NSError? {
                guard let this = self else {
                    return
                }
                this.onNSError(with: request, and: nsError, onCompletion)
            } else if let httpResponse = urlResponse as? HTTPURLResponse {
                let response = buildResponse(with: data, request, and: httpResponse)
                switch response {
                case let .success(response):
                    onCompletion(.success(response))
                case let .failure(error):
                    onCompletion(.failure(error))
                }
            } else {
                onCompletion(
                    .failure(
                        .badResponse(
                            request: request,
                            error: APIClientInternalError.badHTTPResponse(urlResponse)
                        )
                    )
                )
            }
        }
        return urlSessionUploadTask
    }

    private func uploadFromMemoryTask(
        with request: Request,
        body requestBody: Data,
        and urlRequest: URLRequest,
        _ onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        let urlSessionUploadTask: URLSessionUploadTask = uploadTask(
            with: urlRequest, from: requestBody
        ) { [weak self] data, urlResponse, error in
            // The error returned by `uploadTask`, is always of type `NSError`?.
            // Hence, it is safe to check for `NSError` directly.
            if let nsError = error as NSError? {
                guard let this = self else {
                    return
                }
                this.onNSError(with: request, and: nsError, onCompletion)
            } else if let httpResponse = urlResponse as? HTTPURLResponse {
                let response = buildResponse(with: data, request, and: httpResponse)
                switch response {
                case let .success(response):
                    onCompletion(.success(response))
                case let .failure(error):
                    onCompletion(.failure(error))
                }
            } else {
                onCompletion(
                    .failure(
                        .badResponse(
                            request: request,
                            error: APIClientInternalError.badHTTPResponse(urlResponse)
                        )
                    )
                )
            }
        }
        return urlSessionUploadTask
    }

    private func onNSError(
        with request: Request,
        and nsError: NSError,
        _ onCompletion: @escaping (Result<Response, APIClientError>) -> Void
    ) {
        if nsError.domain == nsURLErrorDomain {
            switch nsError.code {
            case noInternetErrorCode:
                return onCompletion(.failure(.noInternet))
            case connectionTimedOutErrorCode:
                return onCompletion(.failure(.connectionTimedOut))
            case requestCancelledErrorCode:
                return onCompletion(.failure(.userCancelledRequest))
            default:
                return onCompletion(
                    .failure(
                        .badResponse(
                            request: request,
                            error: APIClientInternalError.unexpectedError(nsError)
                        )
                    )
                )
            }
        } else {
            return onCompletion(
                .failure(
                    .badResponse(
                        request: request,
                        error: APIClientInternalError.unexpectedError(nsError)
                    )
                )
            )
        }
    }
}

let noInternetErrorCode: Int = -1009
let nsURLErrorDomain: String = "NSURLErrorDomain"
let connectionTimedOutErrorCode: Int = -1001
let requestCancelledErrorCode: Int = -999
