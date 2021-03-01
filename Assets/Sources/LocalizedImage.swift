import Foundation
import LeoSwiftRuntime

public struct LocalizedImage: Codable, Equatable {
    public var en: ThemedImage
    public var ny: ThemedImage?

    enum CodingKeys: String, CodingKey {
        case en
        case ny
    }

    public init(
        en: ThemedImage,
        ny: ThemedImage?
    ) {
        self.en = en
        self.ny = ny
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            en = try values.decode(ThemedImage.self, forKey: .en)
        } catch {
            throw InvalidLocalizedImageError(message: "Unable to decode `en`, error: \(error)")
        }
        do {
            ny = try values.decodeWithDefault(ThemedImage?.self, forKey: .ny, withDefault: nil)
        } catch {
            throw InvalidLocalizedImageError(message: "Unable to decode `ny`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(en, forKey: .en)
        } catch {
            throw InvalidLocalizedImageError(message: "Unable to encode `en`, error: \(error)")
        }
        do {
            try container.encode(ny, forKey: .ny)
        } catch {
            throw InvalidLocalizedImageError(message: "Unable to encode `ny`, error: \(error)")
        }
    }
}

public struct InvalidLocalizedImageError: Error {
    public var message: String?
}
