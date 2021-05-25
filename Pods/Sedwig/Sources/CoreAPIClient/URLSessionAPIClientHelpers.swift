//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

func getURLSession(for configuration: APIClientConfiguration) -> URLSession {
    let urlSessionConfiguration = URLSessionConfiguration.default
    urlSessionConfiguration.timeoutIntervalForRequest = configuration.timeoutIntervalForRequest
    urlSessionConfiguration.timeoutIntervalForResource = configuration.timeoutIntervalForResource
    return URLSession(configuration: urlSessionConfiguration)
}
