import Foundation
import LeoSwiftRuntime

public struct LocalizedText: Codable, Equatable {
    public var en: String
    public var ny: String?

    enum CodingKeys: String, CodingKey {
        case en
        case ny
    }

    public init(
        en: String,
        ny: String?
    ) {
        self.en = en
        self.ny = ny
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            en = try values.decode(String.self, forKey: .en)
        } catch {
            throw InvalidLocalizedTextError(message: "Unable to decode `en`, error: \(error)")
        }
        do {
            ny = try values.decodeWithDefault(String?.self, forKey: .ny, withDefault: nil)
        } catch {
            throw InvalidLocalizedTextError(message: "Unable to decode `ny`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(en, forKey: .en)
        } catch {
            throw InvalidLocalizedTextError(message: "Unable to encode `en`, error: \(error)")
        }
        do {
            try container.encode(ny, forKey: .ny)
        } catch {
            throw InvalidLocalizedTextError(message: "Unable to encode `ny`, error: \(error)")
        }
    }
}

public struct InvalidLocalizedTextError: Error {
    public var message: String?
}
