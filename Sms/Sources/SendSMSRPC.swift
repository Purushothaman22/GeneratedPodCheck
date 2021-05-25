import Foundation
import Sedwig
import LeoSwiftRuntime
import RxSwift


public struct SendSMSRPCRequest: RPCRequest {
    public var to: LeoSwiftRuntime.PhoneNumber
    public var message: String

    enum CodingKeys: String, CodingKey {
        case to
        case message
    }

    

    public init(
        to: LeoSwiftRuntime.PhoneNumber,
        message: String
    ) throws {
        self.to = to
        self.message = message
        try validateMessage(message)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            to = try values.decode(LeoSwiftRuntime.PhoneNumber.self, forKey: .to)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `to`, error: \(error)")
        }
        do {
            message = try values.decode(String.self, forKey: .message)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `message`, error: \(error)")
        }
        try validateMessage(message)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(to, forKey: .to)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `to`, error: \(error)")
        }
        do {
            try container.encode(message, forKey: .message)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `message`, error: \(error)")
        }
    }

    	
	
	private func validateMessage(_ message: String) throws {
	        if message.utf8.count > 140 {
	            throw RPCRuntimeError.invalidRequestError(message: "Attribute message is too long. Size is \(message.utf8.count), Max size is 140")
	        }
	        if message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
	            throw RPCRuntimeError.invalidRequestError(message: "Attribute message cannot be an empty string")
	        }
	}

}


public struct SendSMSRPCResponse: RPCResponse {
    public var messageId: String

    enum CodingKeys: String, CodingKey {
        case messageId
    }

    

    public init(
        messageId: String
    ) {
        self.messageId = messageId
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            messageId = try values.decode(String.self, forKey: .messageId)
        } catch {
            throw InvalidSendSMSRPCResponseError(message: "Unable to decode `messageId`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(messageId, forKey: .messageId)
        } catch {
            throw InvalidSendSMSRPCResponseError(message: "Unable to encode `messageId`, error: \(error)")
        }
    }

    
}

public struct InvalidSendSMSRPCResponseError: Error {
    public var message: String?
    public var error: Error?
}

public enum SendSMSRPCError: RPCError {
    case sendSmsFailed

    

    public var code: String {
        switch self {
            case .sendSmsFailed:
                return "SEND_SMS_FAILED"
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
            case "SEND_SMS_FAILED":
                self = .sendSmsFailed
            default:
                throw RPCRuntimeError.invalidResponseError(message: "Unexpected rawValue \(rawValue)")
            }
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode, error: \(error)")
        }
    }
}

public protocol SendSMSRPC: RPC where Req == SendSMSRPCRequest, Res == SendSMSRPCResponse, Err == SendSMSRPCError {}


public struct SendSMSRPCImpl: SendSMSRPC {
    private let client: AsyncAPIClientRx
    private let authProvider: ClientToServerAuthProvider

    public init(
        asyncAPIClient: AsyncAPIClientRx,
        clientToServerAuthProvider: ClientToServerAuthProvider
    ) {
        client = asyncAPIClient
        authProvider = clientToServerAuthProvider
    }

    public func execute(request: SendSMSRPCRequest) -> Single<RPCResult<SendSMSRPCResponse, SendSMSRPCError>> {
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
                Sedwig.Request(method: .post, path: "home-screen/SendSMS", headers: ["Authorization": authToken], body: reqBody)
            ).map {
                try parseResponse(response: $0, rpcName: "home-screen/SendSMS")
            }
    }
}

