import Foundation
import LeoSwiftRuntime

import Types

    
public enum SendOTPChannel: Codable, Equatable {
    case sms(
        phoneNumber: LeoSwiftRuntime.PhoneNumber)
    case email(
        emailId: LeoSwiftRuntime.EmailId)
    case smsAndEmail(
        phoneNumber: LeoSwiftRuntime.PhoneNumber,
        emailId: LeoSwiftRuntime.EmailId)

    

    public var code: String {
        switch self {
            case .sms:
                return "SMS"
            case .email:
                return "EMAIL"
            case .smsAndEmail:
                return "SMS_AND_EMAIL"
        }
    }

    enum CodingKeys: String, CodingKey {
        case caseString = "case"
        case phoneNumber
        case emailId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .caseString)
        do {
            switch rawValue {
            case "SMS":
                let phoneNumber = try container.decode(LeoSwiftRuntime.PhoneNumber.self, forKey: .phoneNumber)
                self = .sms(
                    phoneNumber: phoneNumber
                )
            case "EMAIL":
                let emailId = try container.decode(LeoSwiftRuntime.EmailId.self, forKey: .emailId)
                self = .email(
                    emailId: emailId
                )
            case "SMS_AND_EMAIL":
                let phoneNumber = try container.decode(LeoSwiftRuntime.PhoneNumber.self, forKey: .phoneNumber)
                let emailId = try container.decode(LeoSwiftRuntime.EmailId.self, forKey: .emailId)
                self = .smsAndEmail(
                    phoneNumber: phoneNumber,
                    emailId: emailId
                )
            default:
                throw InvalidSendOTPChannelError(message: "Unexpected rawValue \(rawValue) for enum SendOTPChannel")
            }
        } catch {
            throw InvalidSendOTPChannelError(message: "Unable to decode SendOTPChannel, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            switch self {
            case let .sms(
                phoneNumber
            ):
                try container.encode(code, forKey: .caseString)
                try container.encode(phoneNumber, forKey: .phoneNumber)
            case let .email(
                emailId
            ):
                try container.encode(code, forKey: .caseString)
                try container.encode(emailId, forKey: .emailId)
            case let .smsAndEmail(
                phoneNumber,
                emailId
            ):
                try container.encode(code, forKey: .caseString)
                try container.encode(phoneNumber, forKey: .phoneNumber)
                try container.encode(emailId, forKey: .emailId)
            }
        } catch {
            throw InvalidSendOTPChannelError(message: "Unable to encode SendOTPChannel, error: \(error)")
        }
    }

    
}


public struct InvalidSendOTPChannelError: Error {
    public var message: String?
    public var error: Error?
}
