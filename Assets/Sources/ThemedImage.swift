import Foundation
import LeoSwiftRuntime

public struct ThemedImage: Codable, Equatable {
    public var light: MultiResolutionBitmapImage
    public var dark: MultiResolutionBitmapImage

    enum CodingKeys: String, CodingKey {
        case light
        case dark
    }

    public init(
        light: MultiResolutionBitmapImage,
        dark: MultiResolutionBitmapImage
    ) {
        self.light = light
        self.dark = dark
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            light = try values.decode(MultiResolutionBitmapImage.self, forKey: .light)
        } catch {
            throw InvalidThemedImageError(message: "Unable to decode `light`, error: \(error)")
        }
        do {
            dark = try values.decode(MultiResolutionBitmapImage.self, forKey: .dark)
        } catch {
            throw InvalidThemedImageError(message: "Unable to decode `dark`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(light, forKey: .light)
        } catch {
            throw InvalidThemedImageError(message: "Unable to encode `light`, error: \(error)")
        }
        do {
            try container.encode(dark, forKey: .dark)
        } catch {
            throw InvalidThemedImageError(message: "Unable to encode `dark`, error: \(error)")
        }
    }
}

public struct InvalidThemedImageError: Error {
    public var message: String?
}
