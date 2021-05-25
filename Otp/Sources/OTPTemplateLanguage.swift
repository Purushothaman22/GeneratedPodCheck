import Foundation
import LeoSwiftRuntime

import Types

    
public enum OTPTemplateLanguage: Codable, Equatable {
    case en
    case ny

    

    public var code: String {
        switch self {
            case .en:
                return "EN"
            case .ny:
                return "NY"
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
            case "EN":
                self = .en
            case "NY":
                self = .ny
            default:
                throw InvalidOTPTemplateLanguageError(message: "Unexpected rawValue \(rawValue) for enum OTPTemplateLanguage")
            }
        } catch {
            throw InvalidOTPTemplateLanguageError(message: "Unable to decode OTPTemplateLanguage, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(code, forKey: .caseString)
        } catch {
            throw InvalidOTPTemplateLanguageError(message: "Unable to encode OTPTemplateLanguage, error: \(error)")
        }
    }

    
}


public struct InvalidOTPTemplateLanguageError: Error {
    public var message: String?
    public var error: Error?
}
