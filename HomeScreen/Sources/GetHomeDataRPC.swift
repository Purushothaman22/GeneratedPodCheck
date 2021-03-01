import Foundation
import Sedwig
import LeoSwiftRuntime
import RxSwift
import Assets


public struct GetHomeDataRPCRequest: RPCRequest {}



public struct GetHomeDataRPCResponse: RPCResponse {
    public var user: User
    public var accounts: [Account]

    enum CodingKeys: String, CodingKey {
        case user
        case accounts
    }

    public init(
        user: User,
        accounts: [Account]
    ) {
        self.user = user
        self.accounts = accounts
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            user = try values.decode(User.self, forKey: .user)
        } catch {
            throw InvalidGetHomeDataRPCResponseError(message: "Unable to decode `user`, error: \(error)")
        }
        do {
            accounts = try values.decode([Account].self, forKey: .accounts)
        } catch {
            throw InvalidGetHomeDataRPCResponseError(message: "Unable to decode `accounts`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(user, forKey: .user)
        } catch {
            throw InvalidGetHomeDataRPCResponseError(message: "Unable to encode `user`, error: \(error)")
        }
        do {
            try container.encode(accounts, forKey: .accounts)
        } catch {
            throw InvalidGetHomeDataRPCResponseError(message: "Unable to encode `accounts`, error: \(error)")
        }
    }
}

public struct InvalidGetHomeDataRPCResponseError: Error {
    public var message: String?
}


public enum GetHomeDataRPCError: RPCError {
    case unknown

    enum CodingKeys: String, CodingKey {
        case caseString = "case"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .caseString)
        do {
            switch rawValue {
            case "UNKNOWN":
                self = .unknown
            default:
                throw RPCRuntimeError.invalidResponseError(message: "Unexpected rawValue \(rawValue)")
            }
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode, error: \(error)")
        }
    }
}

public protocol GetHomeDataRPCCallable  {
    var urlSessionAPIClient: URLSessionAPIClient { get }
}

extension GetHomeDataRPCCallable {
    func execute(request: GetHomeDataRPCRequest) -> Single<RPCResult<GetHomeDataRPCResponse, GetHomeDataRPCError>> {
        let request = Request(
            method: .post,
            path: "https://dev.resolut.tech/postgres/home-screen/GetHomeData"
        )
        return urlSessionAPIClient.sendRequest(request)
            .map { response -> RPCResult<GetHomeDataRPCResponse, GetHomeDataRPCError> in
                guard let data = response.body else {
                    throw RPCRuntimeError.invalidResponseError(message: "Empty response")
                }
                return try parseResponse(
                    response: response,
                    rpcName: "GetHomeData",
                    jsonData: data
                )
            }
    }
}
