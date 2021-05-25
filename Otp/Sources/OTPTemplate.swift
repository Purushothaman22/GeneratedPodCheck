import Foundation
import LeoSwiftRuntime

import Types

    
public enum OTPTemplate: Codable, Equatable {
    case cashIn(
        amount: Types.Amount)
    case cashOut(
        amount: Types.Amount)
    case cardlessWithdrawal(
        amount: Types.Amount)

    

    public var code: String {
        switch self {
            case .cashIn:
                return "CASH_IN"
            case .cashOut:
                return "CASH_OUT"
            case .cardlessWithdrawal:
                return "CARDLESS_WITHDRAWAL"
        }
    }

    enum CodingKeys: String, CodingKey {
        case caseString = "case"
        case amount
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(String.self, forKey: .caseString)
        do {
            switch rawValue {
            case "CASH_IN":
                let amount = try container.decode(Types.Amount.self, forKey: .amount)
                self = .cashIn(
                    amount: amount
                )
            case "CASH_OUT":
                let amount = try container.decode(Types.Amount.self, forKey: .amount)
                self = .cashOut(
                    amount: amount
                )
            case "CARDLESS_WITHDRAWAL":
                let amount = try container.decode(Types.Amount.self, forKey: .amount)
                self = .cardlessWithdrawal(
                    amount: amount
                )
            default:
                throw InvalidOTPTemplateError(message: "Unexpected rawValue \(rawValue) for enum OTPTemplate")
            }
        } catch {
            throw InvalidOTPTemplateError(message: "Unable to decode OTPTemplate, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            switch self {
            case let .cashIn(
                amount
            ):
                try container.encode(code, forKey: .caseString)
                try container.encode(amount, forKey: .amount)
            case let .cashOut(
                amount
            ):
                try container.encode(code, forKey: .caseString)
                try container.encode(amount, forKey: .amount)
            case let .cardlessWithdrawal(
                amount
            ):
                try container.encode(code, forKey: .caseString)
                try container.encode(amount, forKey: .amount)
            }
        } catch {
            throw InvalidOTPTemplateError(message: "Unable to encode OTPTemplate, error: \(error)")
        }
    }

    
}


public struct InvalidOTPTemplateError: Error {
    public var message: String?
    public var error: Error?
}
