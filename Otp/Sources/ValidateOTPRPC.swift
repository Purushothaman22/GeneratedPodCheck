import Foundation
import Sedwig
import LeoSwiftRuntime
import RxSwift
import Types


public struct ValidateOTPRPCRequest: RPCRequest {
    public var id: UUID
    public var otp: String

    enum CodingKeys: String, CodingKey {
        case id
        case otp
    }

    

    public init(
        id: UUID,
        otp: String
    ) {
        self.id = id
        self.otp = otp
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(UUID.self, forKey: .id)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `id`, error: \(error)")
        }
        do {
            otp = try values.decode(String.self, forKey: .otp)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to decode `otp`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `id`, error: \(error)")
        }
        do {
            try container.encode(otp, forKey: .otp)
        } catch {
            throw RPCRuntimeError.invalidRequestError(message: "Unable to encode `otp`, error: \(error)")
        }
    }

    
}


public struct ValidateOTPRPCResponse: RPCResponse {}

public enum ValidateOTPRPCError: RPCError {
    case invalidOtp(
        numberOfValidationAttemptsLeft: Int32)
    case invalidOtpId
    case otpExpired
    case numberOfValidationsExceededLimit

    

    public var code: String {
        switch self {
            case .invalidOtp:
                return "INVALID_OTP"
            case .invalidOtpId:
                return "INVALID_OTP_ID"
            case .otpExpired:
                return "OTP_EXPIRED"
            case .numberOfValidationsExceededLimit:
                return "NUMBER_OF_VALIDATIONS_EXCEEDED_LIMIT"
        }
    }

    enum CodingKeys: String, CodingKey {
        case caseString = "case"
        case numberOfValidationAttemptsLeft
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .caseString)
        do {
            switch rawValue {
            case "INVALID_OTP":
                    let numberOfValidationAttemptsLeft = try container.decode(Int32.self, forKey: .numberOfValidationAttemptsLeft)
                self = .invalidOtp(
                    numberOfValidationAttemptsLeft: numberOfValidationAttemptsLeft
                )
            case "INVALID_OTP_ID":
                self = .invalidOtpId
            case "OTP_EXPIRED":
                self = .otpExpired
            case "NUMBER_OF_VALIDATIONS_EXCEEDED_LIMIT":
                self = .numberOfValidationsExceededLimit
            default:
                throw RPCRuntimeError.invalidResponseError(message: "Unexpected rawValue \(rawValue)")
            }
        } catch {
            throw RPCRuntimeError.invalidResponseError(message: "Unable to decode, error: \(error)")
        }
    }
}

public protocol ValidateOTPRPC: RPC where Req == ValidateOTPRPCRequest, Res == ValidateOTPRPCResponse, Err == ValidateOTPRPCError {}


public struct ValidateOTPRPCImpl: ValidateOTPRPC {
    private let client: AsyncAPIClientRx
    private let authProvider: ClientToServerAuthProvider

    public init(
        asyncAPIClient: AsyncAPIClientRx,
        clientToServerAuthProvider: ClientToServerAuthProvider
    ) {
        client = asyncAPIClient
        authProvider = clientToServerAuthProvider
    }

    public func execute(request: ValidateOTPRPCRequest) -> Single<RPCResult<ValidateOTPRPCResponse, ValidateOTPRPCError>> {
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
                Sedwig.Request(method: .post, path: "home-screen/ValidateOTP", headers: ["Authorization": authToken], body: reqBody)
            ).map {
                try parseResponse(response: $0, rpcName: "home-screen/ValidateOTP")
            }
    }
}

