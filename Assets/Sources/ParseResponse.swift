import Foundation
import LeoSwiftRuntime
import Sedwig

private struct MetaData: Codable {
    public var status: String
    public var error: String?

    private struct MetaError: Codable {
        var code: String
    }

    enum CodingKeys: String, CodingKey {
        case status
        case error
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        let metaError = try values.decodeWithDefault(MetaError?.self, forKey: .error, withDefault: nil)
        error = metaError?.code
    }
}

private struct ResponseBody<Res: RPCResponse, Err: RPCError>: Decodable {
    public var meta: MetaData
    public var response: Res?
    public var error: Err?

    enum CodingKeys: String, CodingKey {
        case meta
        case response
        case error
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            meta = try values.decode(MetaData.self, forKey: .meta)
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode `meta`, error: \(error)")
        }
        do {
            error = try values.decodeWithDefault(Err?.self, forKey: .error, withDefault: nil)
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode `response`, error: \(error)")
        }
        do {
            if error == nil {
                response = try values.decode(Res.self, forKey: .response)
            } else {
                response = try values.decodeWithDefault(Res?.self, forKey: .response, withDefault: nil)
            }
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode `response`, error: \(error)")
        }
    }
}

func parseResponse<Res: RPCResponse, Err: RPCError>(
    response: Response,
    rpcName: String,
    jsonData: Data
) throws -> RPCResult<Res, Err> {
    switch response.statusCode {
    case 200:
        let decoder = JSONDecoder()
        let rpcResponseBody = try decoder.decode(ResponseBody<Res, Err>.self, from: jsonData)
        switch rpcResponseBody.meta.status {
        case "OK":
            if let error = rpcResponseBody.error {
                return .error(error)
            }
            return .response(rpcResponseBody.response!)
        case "ERROR":
            switch rpcResponseBody.meta.error {
            case "INVALID_REQUEST":
                throw RPCRuntimeError.invalidRequestError()
            case "UNAUTHENTICATED":
                throw RPCRuntimeError.unauthenticatedError()
            case "UNAUTHORIZED":
                throw RPCRuntimeError.unauthorizedError()
            case "UNSUPPORTED_CLIENT":
                throw RPCRuntimeError.unsupportedClientError()
            default:
                throw RPCRuntimeError.invalidResponseError(message: "Unexpected meta error code: \(String(describing: rpcResponseBody.meta.error))")
            }
        default:
            throw RPCRuntimeError.invalidResponseError(message: "Unexpected meta status: \(rpcResponseBody.meta.status) from RPC: \(rpcName)")
        }
    case 429, 500, 502, 503:
        if let retryAfter = response.headers.firstValue(named: "Retry-After") {
            if let retryAfter = Float(retryAfter) {
                throw RPCRuntimeError.serverError(
                    message: "RPC: \(rpcName) encountered a server error; status code: \(response.statusCode)",
                    retryAfterSeconds: retryAfter
                )
            }
        }
        throw RPCRuntimeError.serverError(
            message: "RPC: \(rpcName) encountered a server error; status code: \(response.statusCode)",
            retryAfterSeconds: nil
        )
    default: throw RPCRuntimeError.invalidResponseError(message: "Unexpected response status code: \(response.statusCode) from an RPC: \(rpcName)")
    }
}
