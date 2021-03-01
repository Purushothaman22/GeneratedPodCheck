import Foundation
import LeoSwiftRuntime

public struct MultiResolutionBitmapImage: Codable, Equatable {
    public var mdpi: RemoteBitmapImage
    public var xhdpi: RemoteBitmapImage
    public var xxhdpi: RemoteBitmapImage
    public var xxxhdpi: RemoteBitmapImage

    enum CodingKeys: String, CodingKey {
        case mdpi
        case xhdpi
        case xxhdpi
        case xxxhdpi
    }

    public init(
        mdpi: RemoteBitmapImage,
        xhdpi: RemoteBitmapImage,
        xxhdpi: RemoteBitmapImage,
        xxxhdpi: RemoteBitmapImage
    ) {
        self.mdpi = mdpi
        self.xhdpi = xhdpi
        self.xxhdpi = xxhdpi
        self.xxxhdpi = xxxhdpi
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            mdpi = try values.decode(RemoteBitmapImage.self, forKey: .mdpi)
        } catch {
            throw InvalidMultiResolutionBitmapImageError(message: "Unable to decode `mdpi`, error: \(error)")
        }
        do {
            xhdpi = try values.decode(RemoteBitmapImage.self, forKey: .xhdpi)
        } catch {
            throw InvalidMultiResolutionBitmapImageError(message: "Unable to decode `xhdpi`, error: \(error)")
        }
        do {
            xxhdpi = try values.decode(RemoteBitmapImage.self, forKey: .xxhdpi)
        } catch {
            throw InvalidMultiResolutionBitmapImageError(message: "Unable to decode `xxhdpi`, error: \(error)")
        }
        do {
            xxxhdpi = try values.decode(RemoteBitmapImage.self, forKey: .xxxhdpi)
        } catch {
            throw InvalidMultiResolutionBitmapImageError(message: "Unable to decode `xxxhdpi`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(mdpi, forKey: .mdpi)
        } catch {
            throw InvalidMultiResolutionBitmapImageError(message: "Unable to encode `mdpi`, error: \(error)")
        }
        do {
            try container.encode(xhdpi, forKey: .xhdpi)
        } catch {
            throw InvalidMultiResolutionBitmapImageError(message: "Unable to encode `xhdpi`, error: \(error)")
        }
        do {
            try container.encode(xxhdpi, forKey: .xxhdpi)
        } catch {
            throw InvalidMultiResolutionBitmapImageError(message: "Unable to encode `xxhdpi`, error: \(error)")
        }
        do {
            try container.encode(xxxhdpi, forKey: .xxxhdpi)
        } catch {
            throw InvalidMultiResolutionBitmapImageError(message: "Unable to encode `xxxhdpi`, error: \(error)")
        }
    }
}

public struct InvalidMultiResolutionBitmapImageError: Error {
    public var message: String?
}
