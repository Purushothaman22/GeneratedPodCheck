//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation

/// RPCRuntimeError is a list of errors that can occur as part of the RPC framework (i.e. any RPC can throw these errors)
public enum RPCRuntimeError: Error {
    case authTokenExpiredError(message: String? = nil)
    case invalidAuthTokenError(message: String? = nil)
    case invalidRequestError(message: String? = nil, error: Error? = nil)
    case invalidResponseError(message: String? = nil, error: Error? = nil)
    case serverError(message: String? = nil, retryAfterSeconds: Float? = nil)
    case unauthenticatedError(message: String? = nil)
    case unauthorizedError(message: String? = nil)
    case unsupportedClientError(message: String? = nil)
}
