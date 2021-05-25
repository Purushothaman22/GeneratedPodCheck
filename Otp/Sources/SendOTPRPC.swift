import Foundation
import Sedwig
import LeoSwiftRuntime
import RxSwift
import Types


public struct SendOTPRPCRequest: RPCRequest {
    public var sendOTPChannel: SendOTPChannel
    public var otpTemplateLanguage: OTPTemplateLanguage
    public var otpTemplate: OTPTemplate
    public var checkRateLimit: Bool
    public var otpType: OTPType
    public var validityDurationSeconds: Int32

    enum CodingKeys: String, CodingKey {
        case sendOTPChannel
        case otpTemplateLanguage
        case otpTemplate
        case checkRateLimit
        case otpType
        case validityDurationSeconds
    }

    

    public init(
        sendOTPChannel: SendOTPChannel,
        otpTemplateLanguage: OTPTemplateLanguage,
        otpTemplate: OTPTemplate,
        checkRateLimit: Bool,
        otpType: OTPType,
        validityDurationSeconds: Int32
    ) throws {
        self.sendOTPChannel = sendOTPChannel
        self.otpTemplateLanguage = otpTemplateLanguage
        self.otpTemplate = otpTemplate
        self.checkRateLimit = checkRateLimit
        self.otpType = otpType
        self.validityDurationSeconds = validityDurationSeconds
        try validateValidityDurationSeconds(validityDurationSeconds)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            sendOTPChannel = try values.decode(SendOTPChannel.self, forKey: .sendOTPChannel)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `sendOTPChannel`, error: \(error)")
        }
        do {
            otpTemplateLanguage = try values.decode(OTPTemplateLanguage.self, forKey: .otpTemplateLanguage)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `otpTemplateLanguage`, error: \(error)")
        }
        do {
            otpTemplate = try values.decode(OTPTemplate.self, forKey: .otpTemplate)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `otpTemplate`, error: \(error)")
        }
        do {
            checkRateLimit = try values.decode(Bool.self, forKey: .checkRateLimit)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `checkRateLimit`, error: \(error)")
        }
        do {
            otpType = try values.decode(OTPType.self, forKey: .otpType)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `otpType`, error: \(error)")
        }
        do {
            validityDurationSeconds = try values.decode(Int32.self, forKey: .validityDurationSeconds)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `validityDurationSeconds`, error: \(error)")
        }
        try validateValidityDurationSeconds(validityDurationSeconds)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(sendOTPChannel, forKey: .sendOTPChannel)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `sendOTPChannel`, error: \(error)")
        }
        do {
            try container.encode(otpTemplateLanguage, forKey: .otpTemplateLanguage)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `otpTemplateLanguage`, error: \(error)")
        }
        do {
            try container.encode(otpTemplate, forKey: .otpTemplate)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `otpTemplate`, error: \(error)")
        }
        do {
            try container.encode(checkRateLimit, forKey: .checkRateLimit)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `checkRateLimit`, error: \(error)")
        }
        do {
            try container.encode(otpType, forKey: .otpType)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `otpType`, error: \(error)")
        }
        do {
            try container.encode(validityDurationSeconds, forKey: .validityDurationSeconds)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `validityDurationSeconds`, error: \(error)")
        }
    }

    	
	
	private func validateValidityDurationSeconds(_ validityDurationSeconds: Int32) throws {
	        if validityDurationSeconds < 0  {
	            throw RPCRuntimeError.invalidRequestError(message: "Attribute validityDurationSeconds has value \(validityDurationSeconds). Min value is 0.")
	        }
	}

}


public struct SendOTPRPCResponse: RPCResponse {
    public var otpId: UUID
    public var otp: String
    public var expiresAt: Date
    public var nextResendAt: Date
    public var sendEmailSucceeded: Bool
    public var sendSMSSucceeded: Bool

    enum CodingKeys: String, CodingKey {
        case otpId
        case otp
        case expiresAt
        case nextResendAt
        case sendEmailSucceeded
        case sendSMSSucceeded
    }

    

    public init(
        otpId: UUID,
        otp: String,
        expiresAt: Date,
        nextResendAt: Date,
        sendEmailSucceeded: Bool,
        sendSMSSucceeded: Bool
    ) {
        self.otpId = otpId
        self.otp = otp
        self.expiresAt = expiresAt
        self.nextResendAt = nextResendAt
        self.sendEmailSucceeded = sendEmailSucceeded
        self.sendSMSSucceeded = sendSMSSucceeded
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            otpId = try values.decode(UUID.self, forKey: .otpId)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to decode `otpId`, error: \(error)")
        }
        do {
            otp = try values.decode(String.self, forKey: .otp)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to decode `otp`, error: \(error)")
        }
        do {
            expiresAt = try values.decode(Date.self, forKey: .expiresAt)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to decode `expiresAt`, error: \(error)")
        }
        do {
            nextResendAt = try values.decode(Date.self, forKey: .nextResendAt)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to decode `nextResendAt`, error: \(error)")
        }
        do {
            sendEmailSucceeded = try values.decode(Bool.self, forKey: .sendEmailSucceeded)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to decode `sendEmailSucceeded`, error: \(error)")
        }
        do {
            sendSMSSucceeded = try values.decode(Bool.self, forKey: .sendSMSSucceeded)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to decode `sendSMSSucceeded`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(otpId, forKey: .otpId)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to encode `otpId`, error: \(error)")
        }
        do {
            try container.encode(otp, forKey: .otp)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to encode `otp`, error: \(error)")
        }
        do {
            try container.encode(expiresAt, forKey: .expiresAt)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to encode `expiresAt`, error: \(error)")
        }
        do {
            try container.encode(nextResendAt, forKey: .nextResendAt)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to encode `nextResendAt`, error: \(error)")
        }
        do {
            try container.encode(sendEmailSucceeded, forKey: .sendEmailSucceeded)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to encode `sendEmailSucceeded`, error: \(error)")
        }
        do {
            try container.encode(sendSMSSucceeded, forKey: .sendSMSSucceeded)
        } catch {
            throw InvalidSendOTPRPCResponseError(message: "Unable to encode `sendSMSSucceeded`, error: \(error)")
        }
    }

    
}

public struct InvalidSendOTPRPCResponseError: Error {
    public var message: String?
    public var error: Error?
}

public enum SendOTPRPCError: RPCError {
    case rateLimitExceeded

    

    public var code: String {
        switch self {
            case .rateLimitExceeded:
                return "RATE_LIMIT_EXCEEDED"
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
            case "RATE_LIMIT_EXCEEDED":
                self = .rateLimitExceeded
            default:
                throw RPCRuntimeError.invalidResponseError(message: "Unexpected rawValue \(rawValue)")
            }
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode, error: \(error)")
        }
    }
}

public protocol SendOTPRPC: RPC where Req == SendOTPRPCRequest, Res == SendOTPRPCResponse, Err == SendOTPRPCError {}


public struct SendOTPRPCImpl: SendOTPRPC {
    private let client: AsyncAPIClientRx
    private let authProvider: ClientToServerAuthProvider

    public init(
        asyncAPIClient: AsyncAPIClientRx,
        clientToServerAuthProvider: ClientToServerAuthProvider
    ) {
        client = asyncAPIClient
        authProvider = clientToServerAuthProvider
    }

    public func execute(request: SendOTPRPCRequest) -> Single<RPCResult<SendOTPRPCResponse, SendOTPRPCError>> {
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
                Sedwig.Request(method: .post, path: "home-screen/SendOTP", headers: ["Authorization": authToken], body: reqBody)
            ).map {
                try parseResponse(response: $0, rpcName: "home-screen/SendOTP")
            }
    }
}

