import Foundation
import LeoSwiftRuntime


    
public enum Currency: Codable, Equatable {
    case usd
    case mwk
    case zar

    

    public var code: String {
        switch self {
            case .usd:
                return "USD"
            case .mwk:
                return "MWK"
            case .zar:
                return "ZAR"
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
            case "USD":
                self = .usd
            case "MWK":
                self = .mwk
            case "ZAR":
                self = .zar
            default:
                throw InvalidCurrencyError(message: "Unexpected rawValue \(rawValue) for enum Currency")
            }
        } catch {
            throw InvalidCurrencyError(message: "Unable to decode Currency, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(code, forKey: .caseString)
        } catch {
            throw InvalidCurrencyError(message: "Unable to encode Currency, error: \(error)")
        }
    }

    
}


public struct InvalidCurrencyError: Error {
    public var message: String?
    public var error: Error?
}
