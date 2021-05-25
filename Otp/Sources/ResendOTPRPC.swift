import Foundation
import Sedwig
import LeoSwiftRuntime
import RxSwift
import Types


public struct ResendOTPRPCRequest: RPCRequest {
    public var otpId: UUID
    public var otpTemplate: OTPTemplate
    public var validityDurationSeconds: Int32

    enum CodingKeys: String, CodingKey {
        case otpId
        case otpTemplate
        case validityDurationSeconds
    }

    

    public init(
        otpId: UUID,
        otpTemplate: OTPTemplate,
        validityDurationSeconds: Int32
    ) throws {
        self.otpId = otpId
        self.otpTemplate = otpTemplate
        self.validityDurationSeconds = validityDurationSeconds
        try validateValidityDurationSeconds(validityDurationSeconds)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            otpId = try values.decode(UUID.self, forKey: .otpId)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `otpId`, error: \(error)")
        }
        do {
            otpTemplate = try values.decode(OTPTemplate.self, forKey: .otpTemplate)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `otpTemplate`, error: \(error)")
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
            try container.encode(otpId, forKey: .otpId)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `otpId`, error: \(error)")
        }
        do {
            try container.encode(otpTemplate, forKey: .otpTemplate)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `otpTemplate`, error: \(error)")
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


public struct ResendOTPRPCResponse: RPCResponse {
    public var otp: String
    public var expiresAt: Date
    public var numberOfResendAttemptsLeft: Int32
    public var nextResendAt: Date
    public var sendEmailSucceded: Bool
    public var sendSMSSucceded: Bool

    enum CodingKeys: String, CodingKey {
        case otp
        case expiresAt
        case numberOfResendAttemptsLeft
        case nextResendAt
        case sendEmailSucceded
        case sendSMSSucceded
    }

    

    public init(
        otp: String,
        expiresAt: Date,
        numberOfResendAttemptsLeft: Int32,
        nextResendAt: Date,
        sendEmailSucceded: Bool,
        sendSMSSucceded: Bool
    ) {
        self.otp = otp
        self.expiresAt = expiresAt
        self.numberOfResendAttemptsLeft = numberOfResendAttemptsLeft
        self.nextResendAt = nextResendAt
        self.sendEmailSucceded = sendEmailSucceded
        self.sendSMSSucceded = sendSMSSucceded
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            otp = try values.decode(String.self, forKey: .otp)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to decode `otp`, error: \(error)")
        }
        do {
            expiresAt = try values.decode(Date.self, forKey: .expiresAt)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to decode `expiresAt`, error: \(error)")
        }
        do {
            numberOfResendAttemptsLeft = try values.decode(Int32.self, forKey: .numberOfResendAttemptsLeft)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to decode `numberOfResendAttemptsLeft`, error: \(error)")
        }
        do {
            nextResendAt = try values.decode(Date.self, forKey: .nextResendAt)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to decode `nextResendAt`, error: \(error)")
        }
        do {
            sendEmailSucceded = try values.decode(Bool.self, forKey: .sendEmailSucceded)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to decode `sendEmailSucceded`, error: \(error)")
        }
        do {
            sendSMSSucceded = try values.decode(Bool.self, forKey: .sendSMSSucceded)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to decode `sendSMSSucceded`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(otp, forKey: .otp)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to encode `otp`, error: \(error)")
        }
        do {
            try container.encode(expiresAt, forKey: .expiresAt)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to encode `expiresAt`, error: \(error)")
        }
        do {
            try container.encode(numberOfResendAttemptsLeft, forKey: .numberOfResendAttemptsLeft)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to encode `numberOfResendAttemptsLeft`, error: \(error)")
        }
        do {
            try container.encode(nextResendAt, forKey: .nextResendAt)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to encode `nextResendAt`, error: \(error)")
        }
        do {
            try container.encode(sendEmailSucceded, forKey: .sendEmailSucceded)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to encode `sendEmailSucceded`, error: \(error)")
        }
        do {
            try container.encode(sendSMSSucceded, forKey: .sendSMSSucceded)
        } catch {
            throw InvalidResendOTPRPCResponseError(message: "Unable to encode `sendSMSSucceded`, error: \(error)")
        }
    }

    
}

public struct InvalidResendOTPRPCResponseError: Error {
    public var message: String?
    public var error: Error?
}

public enum ResendOTPRPCError: RPCError {
    case invalidOtpId
    case numberOfResendAttemptsExceededLimit
    case waitForResend(
        nextResendAt: Date)
    case rateLimitExceeded
    case otpExpired

    

    public var code: String {
        switch self {
            case .invalidOtpId:
                return "INVALID_OTP_ID"
            case .numberOfResendAttemptsExceededLimit:
                return "NUMBER_OF_RESEND_ATTEMPTS_EXCEEDED_LIMIT"
            case .waitForResend:
                return "WAIT_FOR_RESEND"
            case .rateLimitExceeded:
                return "RATE_LIMIT_EXCEEDED"
            case .otpExpired:
                return "OTP_EXPIRED"
        }
    }

    enum CodingKeys: String, CodingKey {
        case caseString = "case"
        case nextResendAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .caseString)
        do {
            switch rawValue {
            case "INVALID_OTP_ID":
                self = .invalidOtpId
            case "NUMBER_OF_RESEND_ATTEMPTS_EXCEEDED_LIMIT":
                self = .numberOfResendAttemptsExceededLimit
            case "WAIT_FOR_RESEND":
                    let nextResendAt = try container.decode(Date.self, forKey: .nextResendAt)
                self = .waitForResend(
                    nextResendAt: nextResendAt
                )
            case "RATE_LIMIT_EXCEEDED":
                self = .rateLimitExceeded
            case "OTP_EXPIRED":
                self = .otpExpired
            default:
                throw RPCRuntimeError.invalidResponseError(message: "Unexpected rawValue \(rawValue)")
            }
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode, error: \(error)")
        }
    }
}

public protocol ResendOTPRPC: RPC where Req == ResendOTPRPCRequest, Res == ResendOTPRPCResponse, Err == ResendOTPRPCError {}


public struct ResendOTPRPCImpl: ResendOTPRPC {
    private let client: AsyncAPIClientRx
    private let authProvider: ClientToServerAuthProvider

    public init(
        asyncAPIClient: AsyncAPIClientRx,
        clientToServerAuthProvider: ClientToServerAuthProvider
    ) {
        client = asyncAPIClient
        authProvider = clientToServerAuthProvider
    }

    public func execute(request: ResendOTPRPCRequest) -> Single<RPCResult<ResendOTPRPCResponse, ResendOTPRPCError>> {
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
                Sedwig.Request(method: .post, path: "home-screen/ResendOTP", headers: ["Authorization": authToken], body: reqBody)
            ).map {
                try parseResponse(response: $0, rpcName: "home-screen/ResendOTP")
            }
    }
}

