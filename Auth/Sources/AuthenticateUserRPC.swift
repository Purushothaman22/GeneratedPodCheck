import Foundation
import Sedwig
import LeoSwiftRuntime
import RxSwift


public struct AuthenticateUserRPCRequest: RPCRequest {
    public var authToken: String

    enum CodingKeys: String, CodingKey {
        case authToken
    }

    

    public init(
        authToken: String
    ) {
        self.authToken = authToken
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            authToken = try values.decode(String.self, forKey: .authToken)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `authToken`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(authToken, forKey: .authToken)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `authToken`, error: \(error)")
        }
    }

    
}


public struct AuthenticateUserRPCResponse: RPCResponse {
    public var userIdentity: UserIdentity

    enum CodingKeys: String, CodingKey {
        case userIdentity
    }

    

    public init(
        userIdentity: UserIdentity
    ) {
        self.userIdentity = userIdentity
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            userIdentity = try values.decode(UserIdentity.self, forKey: .userIdentity)
        } catch {
            throw InvalidAuthenticateUserRPCResponseError(message: "Unable to decode `userIdentity`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(userIdentity, forKey: .userIdentity)
        } catch {
            throw InvalidAuthenticateUserRPCResponseError(message: "Unable to encode `userIdentity`, error: \(error)")
        }
    }

    
}

public struct InvalidAuthenticateUserRPCResponseError: Error {
    public var message: String?
    public var error: Error?
}

public enum AuthenticateUserRPCError: RPCError {
    case invalidAuthenticationToken
    case authTokenExpired

    

    public var code: String {
        switch self {
            case .invalidAuthenticationToken:
                return "INVALID_AUTHENTICATION_TOKEN"
            case .authTokenExpired:
                return "AUTH_TOKEN_EXPIRED"
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
            case "INVALID_AUTHENTICATION_TOKEN":
                self = .invalidAuthenticationToken
            case "AUTH_TOKEN_EXPIRED":
                self = .authTokenExpired
            default:
                throw RPCRuntimeError.invalidResponseError(message: "Unexpected rawValue \(rawValue)")
            }
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode, error: \(error)")
        }
    }
}

public protocol AuthenticateUserRPC: RPC where Req == AuthenticateUserRPCRequest, Res == AuthenticateUserRPCResponse, Err == AuthenticateUserRPCError {}


public struct AuthenticateUserRPCImpl: AuthenticateUserRPC {
    private let client: AsyncAPIClientRx
    private let authProvider: ClientToServerAuthProvider

    public init(
        asyncAPIClient: AsyncAPIClientRx,
        clientToServerAuthProvider: ClientToServerAuthProvider
    ) {
        client = asyncAPIClient
        authProvider = clientToServerAuthProvider
    }

    public func execute(request: AuthenticateUserRPCRequest) -> Single<RPCResult<AuthenticateUserRPCResponse, AuthenticateUserRPCError>> {
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
                Sedwig.Request(method: .post, path: "home-screen/AuthenticateUser", headers: ["Authorization": authToken], body: reqBody)
            ).map {
                try parseResponse(response: $0, rpcName: "home-screen/AuthenticateUser")
            }
    }
}

