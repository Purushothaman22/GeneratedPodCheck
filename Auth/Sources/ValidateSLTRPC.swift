import Foundation
import Sedwig
import LeoSwiftRuntime
import RxSwift


public struct ValidateSLTRPCRequest: RPCRequest {
    public var slt: String

    enum CodingKeys: String, CodingKey {
        case slt
    }

    

    public init(
        slt: String
    ) {
        self.slt = slt
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            slt = try values.decode(String.self, forKey: .slt)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `slt`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(slt, forKey: .slt)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `slt`, error: \(error)")
        }
    }

    
}


public struct ValidateSLTRPCResponse: RPCResponse {
    public var userIdentity: UserIdentity
    public var slt: String?

    enum CodingKeys: String, CodingKey {
        case userIdentity
        case slt
    }

    

    public init(
        userIdentity: UserIdentity,
        slt: String?
    ) {
        self.userIdentity = userIdentity
        self.slt = slt
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            userIdentity = try values.decode(UserIdentity.self, forKey: .userIdentity)
        } catch {
            throw InvalidValidateSLTRPCResponseError(message: "Unable to decode `userIdentity`, error: \(error)")
        }
        do {
            slt = try values.decodeWithDefault(String?.self, forKey: .slt, withDefault: nil)
        } catch {
            throw InvalidValidateSLTRPCResponseError(message: "Unable to decode `slt`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(userIdentity, forKey: .userIdentity)
        } catch {
            throw InvalidValidateSLTRPCResponseError(message: "Unable to encode `userIdentity`, error: \(error)")
        }
        do {
            try container.encode(slt, forKey: .slt)
        } catch {
            throw InvalidValidateSLTRPCResponseError(message: "Unable to encode `slt`, error: \(error)")
        }
    }

    
}

public struct InvalidValidateSLTRPCResponseError: Error {
    public var message: String?
    public var error: Error?
}

public enum ValidateSLTRPCError: RPCError {
    case invalidSlt
    case invalidLlt

    

    public var code: String {
        switch self {
            case .invalidSlt:
                return "INVALID_SLT"
            case .invalidLlt:
                return "INVALID_LLT"
        }
    }

    enum CodingKeys: String, CodingKey {
        case caseString = "case"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .caseString)
        do {
            switch rawValue {
            case "INVALID_SLT":
                self = .invalidSlt
            case "INVALID_LLT":
                self = .invalidLlt
            default:
                throw RPCRuntimeError.invalidResponseError(message: "Unexpected rawValue \(rawValue)")
            }
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode, error: \(error)")
        }
    }
}

public protocol ValidateSLTRPC: RPC where Req == ValidateSLTRPCRequest, Res == ValidateSLTRPCResponse, Err == ValidateSLTRPCError {}


public struct ValidateSLTRPCImpl: ValidateSLTRPC {
    private let client: AsyncAPIClientRx
    private let authProvider: ClientToServerAuthProvider

    public init(
        asyncAPIClient: AsyncAPIClientRx,
        clientToServerAuthProvider: ClientToServerAuthProvider
    ) {
        client = asyncAPIClient
        authProvider = clientToServerAuthProvider
    }

    public func execute(request: ValidateSLTRPCRequest) -> Single<RPCResult<ValidateSLTRPCResponse, ValidateSLTRPCError>> {
        let reqBody: Data
        do {
            let encoder = JSONEncoder()
            reqBody = try encoder.encode(request)
        } catch let e {
            return Single.error(RPCRuntimeError.invalidRequestError(error: e))
        }
        let authToken = authProvider.getAuthToken()
        return client
            .sendRequest(
                Sedwig.Request(method: .post, path: "home-screen/ValidateSLT", headers: ["Authorization": authToken], body: reqBody)
            ).map {
                try parseResponse(response: $0, rpcName: "home-screen/ValidateSLT")
            }
    }
}

