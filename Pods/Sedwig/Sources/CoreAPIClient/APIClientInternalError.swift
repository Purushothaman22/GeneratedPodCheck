//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

enum APIClientInternalError: Error {
    case badHTTPResponse(URLResponse?)
    case unexpectedError(Error?)
}
