import Foundation
import LeoSwiftRuntime

public struct ThemedColor: Codable, Equatable {
    public var lightColor: String
    public var darkColor: String

    enum CodingKeys: String, CodingKey {
        case lightColor
        case darkColor
    }

    public init(
        lightColor: String,
        darkColor: String
    ) {
        self.lightColor = lightColor
        self.darkColor = darkColor
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            lightColor = try values.decode(String.self, forKey: .lightColor)
        } catch {
            throw InvalidThemedColorError(message: "Unable to decode `lightColor`, error: \(error)")
        }
        do {
            darkColor = try values.decode(String.self, forKey: .darkColor)
        } catch {
            throw InvalidThemedColorError(message: "Unable to decode `darkColor`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(lightColor, forKey: .lightColor)
        } catch {
            throw InvalidThemedColorError(message: "Unable to encode `lightColor`, error: \(error)")
        }
        do {
            try container.encode(darkColor, forKey: .darkColor)
        } catch {
            throw InvalidThemedColorError(message: "Unable to encode `darkColor`, error: \(error)")
        }
    }
}

public struct InvalidThemedColorError: Error {
    public var message: String?
}
