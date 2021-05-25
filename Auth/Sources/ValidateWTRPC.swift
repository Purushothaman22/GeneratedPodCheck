import Foundation
import Sedwig
import LeoSwiftRuntime
import RxSwift


public struct ValidateWTRPCRequest: RPCRequest {
    public var wt: String

    enum CodingKeys: String, CodingKey {
        case wt
    }

    

    public init(
        wt: String
    ) {
        self.wt = wt
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            wt = try values.decode(String.self, forKey: .wt)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `wt`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(wt, forKey: .wt)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `wt`, error: \(error)")
        }
    }

    
}


public struct ValidateWTRPCResponse: RPCResponse {
    public var userIdentity: UserIdentity
    public var wt: WebToken?

    enum CodingKeys: String, CodingKey {
        case userIdentity
        case wt
    }

    

    public init(
        userIdentity: UserIdentity,
        wt: WebToken?
    ) {
        self.userIdentity = userIdentity
        self.wt = wt
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            userIdentity = try values.decode(UserIdentity.self, forKey: .userIdentity)
        } catch {
            throw InvalidValidateWTRPCResponseError(message: "Unable to decode `userIdentity`, error: \(error)")
        }
        do {
            wt = try values.decodeWithDefault(WebToken?.self, forKey: .wt, withDefault: nil)
        } catch {
            throw InvalidValidateWTRPCResponseError(message: "Unable to decode `wt`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(userIdentity, forKey: .userIdentity)
        } catch {
            throw InvalidValidateWTRPCResponseError(message: "Unable to encode `userIdentity`, error: \(error)")
        }
        do {
            try container.encode(wt, forKey: .wt)
        } catch {
            throw InvalidValidateWTRPCResponseError(message: "Unable to encode `wt`, error: \(error)")
        }
    }

    
}

public struct InvalidValidateWTRPCResponseError: Error {
    public var message: String?
    public var error: Error?
}

public enum ValidateWTRPCError: RPCError {
    case invalidWt

    

    public var code: String {
        switch self {
            case .invalidWt:
                return "INVALID_WT"
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
            case "INVALID_WT":
                self = .invalidWt
            default:
                throw RPCRuntimeError.invalidResponseError(message: "Unexpected rawValue \(rawValue)")
            }
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode, error: \(error)")
        }
    }
}

public protocol ValidateWTRPC: RPC where Req == ValidateWTRPCRequest, Res == ValidateWTRPCResponse, Err == ValidateWTRPCError {}


public struct ValidateWTRPCImpl: ValidateWTRPC {
    private let client: AsyncAPIClientRx
    private let authProvider: ClientToServerAuthProvider

    public init(
        asyncAPIClient: AsyncAPIClientRx,
        clientToServerAuthProvider: ClientToServerAuthProvider
    ) {
        client = asyncAPIClient
        authProvider = clientToServerAuthProvider
    }

    public func execute(request: ValidateWTRPCRequest) -> Single<RPCResult<ValidateWTRPCResponse, ValidateWTRPCError>> {
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
                Sedwig.Request(method: .post, path: "home-screen/ValidateWT", headers: ["Authorization": authToken], body: reqBody)
            ).map {
                try parseResponse(response: $0, rpcName: "home-screen/ValidateWT")
            }
    }
}

