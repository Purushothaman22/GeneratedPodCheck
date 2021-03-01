import Foundation
import LeoSwiftRuntime

public struct LayoutSection: Codable, Equatable {
    public var background: Background?

    enum CodingKeys: String, CodingKey {
        case background
    }

    public init(
        background: Background?
    ) {
        self.background = background
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            background = try values.decodeWithDefault(Background?.self, forKey: .background, withDefault: nil)
        } catch {
            throw InvalidLayoutSectionError(message: "Unable to decode `background`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(background, forKey: .background)
        } catch {
            throw InvalidLayoutSectionError(message: "Unable to encode `background`, error: \(error)")
        }
    }
}

public struct InvalidLayoutSectionError: Error {
    public var message: String?
}
