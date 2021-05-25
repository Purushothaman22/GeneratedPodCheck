import Foundation
import LeoSwiftRuntime

public struct Amount: Codable, Equatable {
    public var amount: Int64
    public var currency: Currency

    enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }

    

    public init(
        amount: Int64,
        currency: Currency
    ) {
        self.amount = amount
        self.currency = currency
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            amount = try values.decode(Int64.self, forKey: .amount)
        } catch {
            throw InvalidAmountError(message: "Unable to decode `amount`, error: \(error)")
        }
        do {
            currency = try values.decode(Currency.self, forKey: .currency)
        } catch {
            throw InvalidAmountError(message: "Unable to decode `currency`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(amount, forKey: .amount)
        } catch {
            throw InvalidAmountError(message: "Unable to encode `amount`, error: \(error)")
        }
        do {
            try container.encode(currency, forKey: .currency)
        } catch {
            throw InvalidAmountError(message: "Unable to encode `currency`, error: \(error)")
        }
    }

    
}

public struct InvalidAmountError: Error {
    public var message: String?
    public var error: Error?
}
