import Foundation
import LeoSwiftRuntime

public struct WebToken: Codable, Equatable {
    public var wt: String
    public var expiresAt: Date

    enum CodingKeys: String, CodingKey {
        case wt
        case expiresAt
    }

    

    public init(
        wt: String,
        expiresAt: Date
    ) {
        self.wt = wt
        self.expiresAt = expiresAt
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            wt = try values.decode(String.self, forKey: .wt)
        } catch {
            throw InvalidWebTokenError(message: "Unable to decode `wt`, error: \(error)")
        }
        do {
            expiresAt = try values.decode(Date.self, forKey: .expiresAt)
        } catch {
            throw InvalidWebTokenError(message: "Unable to decode `expiresAt`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(wt, forKey: .wt)
        } catch {
            throw InvalidWebTokenError(message: "Unable to encode `wt`, error: \(error)")
        }
        do {
            try container.encode(expiresAt, forKey: .expiresAt)
        } catch {
            throw InvalidWebTokenError(message: "Unable to encode `expiresAt`, error: \(error)")
        }
    }

    
}

public struct InvalidWebTokenError: Error {
    public var message: String?
    public var error: Error?
}
