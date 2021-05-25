import Foundation
import LeoSwiftRuntime

import Types

    
public enum OTPType: Codable, Equatable {
    case critical
    case normal

    

    public var code: String {
        switch self {
            case .critical:
                return "CRITICAL"
            case .normal:
                return "NORMAL"
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
            case "CRITICAL":
                self = .critical
            case "NORMAL":
                self = .normal
            default:
                throw InvalidOTPTypeError(message: "Unexpected rawValue \(rawValue) for enum OTPType")
            }
        } catch {
            throw InvalidOTPTypeError(message: "Unable to decode OTPType, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(code, forKey: .caseString)
        } catch {
            throw InvalidOTPTypeError(message: "Unable to encode OTPType, error: \(error)")
        }
    }

    
}


public struct InvalidOTPTypeError: Error {
    public var message: String?
    public var error: Error?
}
