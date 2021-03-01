import Foundation
import LeoSwiftRuntime

public struct Background: Codable, Equatable {
    public var backgroundColor: ThemedColor?
    public var cornerRadius: CornerRadius?

    enum CodingKeys: String, CodingKey {
        case backgroundColor
        case cornerRadius
    }

    public init(
        backgroundColor: ThemedColor?,
        cornerRadius: CornerRadius?
    ) {
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            backgroundColor = try values.decodeWithDefault(ThemedColor?.self, forKey: .backgroundColor, withDefault: nil)
        } catch {
            throw InvalidBackgroundError(message: "Unable to decode `backgroundColor`, error: \(error)")
        }
        do {
            cornerRadius = try values.decodeWithDefault(CornerRadius?.self, forKey: .cornerRadius, withDefault: nil)
        } catch {
            throw InvalidBackgroundError(message: "Unable to decode `cornerRadius`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(backgroundColor, forKey: .backgroundColor)
        } catch {
            throw InvalidBackgroundError(message: "Unable to encode `backgroundColor`, error: \(error)")
        }
        do {
            try container.encode(cornerRadius, forKey: .cornerRadius)
        } catch {
            throw InvalidBackgroundError(message: "Unable to encode `cornerRadius`, error: \(error)")
        }
    }
}

public struct InvalidBackgroundError: Error {
    public var message: String?
}
