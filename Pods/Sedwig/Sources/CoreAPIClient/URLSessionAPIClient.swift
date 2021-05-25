//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// Coordinates core networking requests and responses.
public class URLSessionAPIClient: APIClient {
    private let urlSession: Networker
    private let configuration: APIClientConfiguration
    /// Creates an instance of URLSessionAPIClient.
    public convenience init(
        withConfiguration configuration: APIClientConfiguration
    ) {
        let urlSession = getURLSession(for: configuration)
        self.init(with: urlSession, and: configuration)
    }

    // This initializer is only used by unit tests, and hence it is declared internal.
    init(
        with urlSession: Networker = getURLSession(for: APIClientConfiguration()),
        and configuration: APIClientConfiguration = APIClientConfiguration()
    ) {
        self.urlSession = urlSession
        self.configuration = configuration
    }

    /// Makes an HTTP request.
    /// - Parameters:
    ///   - request: An instance of `Request`.
    ///   - onResponse: A closure whose execution is guaranteed
    ///   (in case of getting a response or error), except if self gets deinitialized.
    public func sendRequest(
        _ request: Request,
        _ onResponse: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        logRequest(request)
        let task = urlSession.networkDataTask(
            with: buildConfiguredRequest(for: request)
        ) { [weak self] result in
            switch result {
            case let .success(response):
                self?.onNetworkResponse(response, onResponse)
            case let .failure(error):
                self?.logResponseError(for: error)
                onResponse(
                    .failure(error)
                )
            }
        }
        task.resume()
        return task
    }

    public func sendDownloadRequest(
        _ request: Request,
        storeResourceAt resourceStorageURL: URL,
        _ onResponse: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        logRequest(request)
        let downloadTask = urlSession.networkDownloadTask(
            with: buildConfiguredRequest(for: request), and: resourceStorageURL
        ) { [weak self] result in
            switch result {
            case let .success(downloadResponse):
                self?.onNetworkResponse(downloadResponse, onResponse)
            case let .failure(error):
                self?.logResponseError(for: error)
                onResponse(
                    .failure(error)
                )
            }
        }
        downloadTask.resume()
        return downloadTask
    }

    public func sendUploadRequest(
        _ request: Request,
        _ onUploadResponse: @escaping (Result<Response, APIClientError>) -> Void
    ) -> NetworkTask {
        log(
            with: configuration.logConfiguration.logger,
            at: configuration.logConfiguration.requestMetadata,
            using: configuration.logConfiguration.messageSanitizer
        ) {
            "\(request)"
        }
        let uploadTask = urlSession.networkUploadTask(
            with: buildConfiguredRequest(for: request)
        ) { [weak self] result in
            switch result {
            case let .success(response):
                self?.onNetworkResponse(response, onUploadResponse)
            case let .failure(error):
                self?.logResponseError(for: .unexpectedError)
                onUploadResponse(
                    .failure(error)
                )
            }
        }
        uploadTask.resume()
        return uploadTask
    }

    private func onNetworkResponse(
        _ networkResponse: Response,
        _ onResponse: @escaping (Result<Response, APIClientError>) -> Void
    ) {
        logResponseMetadata(networkResponse)
        var mutableResponse = networkResponse
        log(
            with: configuration.logConfiguration.logger,
            at: configuration.logConfiguration.responseBody,
            using: configuration.logConfiguration.messageSanitizer
        ) {
            let responseStringBody = mutableResponse.stringBody
            let responsePath = mutableResponse.request.path
            // We use request URL as a substitute mechanism for request identifiers.
            // If a response body could not be parsed, we can identify the corresponding
            // request using the URL.
            return "\(stringBody: responseStringBody, url: responsePath, for: .response)"
        }
        onResponse(
            .success(mutableResponse)
        )
    }

    private func buildConfiguredRequest(for request: Request) -> Request {
        let configuredQueryParameters: QueryParameters
        let configuredHeaders: Headers
        if request.omitDefaultQueryParameters {
            configuredQueryParameters = request.queryParameters
        } else {
            configuredQueryParameters = QueryParameters(
                request.queryParameters.all() + configuration.defaultQueryParameters.all()
            )
        }
        if request.omitDefaultHeaders {
            configuredHeaders = request.headers
        } else {
            configuredHeaders = Headers(
                request.headers.all() + configuration.defaultHeaders.all()
            )
        }
        return setupRequest(
            with: request, configuredHeaders, and: configuredQueryParameters
        )
    }

    func setupRequest(
        with request: Request, _ configuredHeaders: Headers,
        and configuredQueryParameters: QueryParameters

    ) -> Request {
        let urlString: String
        if configuration.baseURL.hasSuffix("/"), request.path.hasPrefix("/") {
            var baseURL = configuration.baseURL
            baseURL.removeLast()
            urlString = baseURL + request.path
        } else if !configuration.baseURL.hasSuffix("/"), !request.path.hasPrefix("/"), !configuration.baseURL.isEmpty {
            urlString = configuration.baseURL + "/" + request.path
        } else {
            urlString = configuration.baseURL + request.path
        }
        if let requestBodySource = request.bodySource {
            switch requestBodySource {
            case let .inMemory(requestBody):
                return Request(
                    method: request.method,
                    path: urlString,
                    headers: configuredHeaders,
                    queryParameters: configuredQueryParameters,
                    body: requestBody,
                    omitDefaultHeaders: request.omitDefaultHeaders,
                    omitDefaultQueryParameters: request.omitDefaultQueryParameters
                )
            case let .onDisk(resourceLocation):
                return Request(
                    method: request.method,
                    path: urlString,
                    headers: configuredHeaders,
                    queryParameters: configuredQueryParameters,
                    uploadSourceLocation: resourceLocation,
                    omitDefaultHeaders: request.omitDefaultHeaders,
                    omitDefaultQueryParameters: request.omitDefaultQueryParameters
                )
            }
        } else {
            return Request(
                method: request.method,
                path: urlString,
                headers: configuredHeaders,
                queryParameters: configuredQueryParameters,
                body: nil,
                omitDefaultHeaders: request.omitDefaultHeaders,
                omitDefaultQueryParameters: request.omitDefaultQueryParameters
            )
        }
    }

    private func logResponseError(for error: APIClientError) {
        log(
            with: configuration.logConfiguration.logger,
            at: configuration.logConfiguration.responseMetadata,
            using: configuration.logConfiguration.messageSanitizer
        ) {
            """
            Encountered error:
            |Description: \(forError: error)
            |Error: \(error)
            """
        }
    }

    private func logRequest(_ request: Request) {
        log(
            with: configuration.logConfiguration.logger,
            at: configuration.logConfiguration.requestMetadata,
            using: configuration.logConfiguration.messageSanitizer
        ) {
            "\(request)"
        }
        // We use request URL as a substitute mechanism for request identifiers.
        // If a request body could not be parsed, we can identify the corresponding
        // request using the URL.
        if let requestBodySource = request.bodySource {
            logRequestBody(requestBodySource, request.path)
        } else {
            logRequestBodyNotPresent(request.path)
        }
    }

    private func logRequestBodyNotPresent(_ requestPath: String) {
        log(
            with: configuration.logConfiguration.logger,
            at: configuration.logConfiguration.requestBody,
            using: configuration.logConfiguration.messageSanitizer
        ) {
            "\(stringBody: nil, url: requestPath, for: .request)"
        }
    }

    private func logRequestBody(_ requestBodySource: BodySource, _ requestPath: String) {
        switch requestBodySource {
        case let .inMemory(body):
            let requestStringBody = String(decoding: body, as: UTF8.self)
            log(
                with: configuration.logConfiguration.logger,
                at: configuration.logConfiguration.requestBody,
                using: configuration.logConfiguration.messageSanitizer
            ) {
                "\(stringBody: requestStringBody, url: requestPath, for: .request)"
            }
        case let .onDisk(fileLocation):
            let uploadSourceLocationString = "Upload source URL: \(fileLocation)"
            log(
                with: configuration.logConfiguration.logger,
                at: configuration.logConfiguration.requestBody,
                using: configuration.logConfiguration.messageSanitizer
            ) {
                "\(stringBody: uploadSourceLocationString, url: requestPath, for: .request)"
            }
        }
    }

    private func logResponseMetadata(_ response: Response) {
        log(
            with: configuration.logConfiguration.logger,
            at: configuration.logConfiguration.responseMetadata,
            using: configuration.logConfiguration.messageSanitizer
        ) {
            "\(response)"
        }
    }

    private func log(
        with logger: Logger,
        at level: LogLevel,
        using messageSanitizer: LogMessageSanitizer,
        _ messageGenerator: () -> String
    ) {
        switch level {
        case .debug:
            logger.debug(
                message: {
                    messageSanitizer(messageGenerator())
                }
            )
        case .info:
            logger.info(
                message: {
                    messageSanitizer(messageGenerator())
                }
            )
        case .warn:
            logger.warn(
                message: {
                    messageSanitizer(messageGenerator())
                }
            )
        case .error:
            logger.error(
                message: {
                    messageSanitizer(messageGenerator())
                }
            )
        case .none:
            () // No - op
        }
    }
}
