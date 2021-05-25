//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation
import RxSwift
import Sedwig

/// RPCRequest represents a RPC request .
public protocol RPCRequest: Codable, Equatable {}

/// RPCResponse represents a response returned from an RPC.
public protocol RPCResponse: Codable, Equatable {}

/// RPCError represents represents an error returned from an RPC.
public protocol RPCError: Decodable, Equatable {
    var code: String { get }
}

/// RPCResult represents the result of a RPC.
public enum RPCResult<R: RPCResponse, E: RPCError> {
    case response(R)
    case error(E)
}

/// Definition of a RPC.
public protocol RPC {
    associatedtype Req: RPCRequest
    associatedtype Res: RPCResponse
    associatedtype Err: RPCError

    /// Executes RPC
    /// - Parameter request: RPC request object.
    /// - Returns: RPC result.
    func execute(request: Req) -> Single<RPCResult<Res, Err>>
}
