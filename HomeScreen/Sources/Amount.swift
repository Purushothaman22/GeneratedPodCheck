import Foundation
import LeoSwiftRuntime
import Assets

public struct Amount: Codable, Equatable {
    public var amount: Int64

    enum CodingKeys: String, CodingKey {
        case amount
    }

    public init(
        amount: Int64
    ) {
        self.amount = amount
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            amount = try values.decode(Int64.self, forKey: .amount)
        } catch {
            throw InvalidAmountError(message: "Unable to decode `amount`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(amount, forKey: .amount)
        } catch {
            throw InvalidAmountError(message: "Unable to encode `amount`, error: \(error)")
        }
    }
}

public struct InvalidAmountError: Error {
    public var message: String?
}
