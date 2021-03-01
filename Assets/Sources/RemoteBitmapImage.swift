import Foundation
import LeoSwiftRuntime

public struct RemoteBitmapImage: Codable, Equatable {
    public var url: URL
    public var imageType: BitmapImageType
    public var width: Int32
    public var height: Int32

    enum CodingKeys: String, CodingKey {
        case url
        case imageType
        case width
        case height
    }

    public init(
        url: URL,
        imageType: BitmapImageType,
        width: Int32,
        height: Int32
    ) {
        self.url = url
        self.imageType = imageType
        self.width = width
        self.height = height
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            url = try values.decode(URL.self, forKey: .url)
        } catch {
            throw InvalidRemoteBitmapImageError(message: "Unable to decode `url`, error: \(error)")
        }
        do {
            imageType = try values.decode(BitmapImageType.self, forKey: .imageType)
        } catch {
            throw InvalidRemoteBitmapImageError(message: "Unable to decode `imageType`, error: \(error)")
        }
        do {
            width = try values.decode(Int32.self, forKey: .width)
        } catch {
            throw InvalidRemoteBitmapImageError(message: "Unable to decode `width`, error: \(error)")
        }
        do {
            height = try values.decode(Int32.self, forKey: .height)
        } catch {
            throw InvalidRemoteBitmapImageError(message: "Unable to decode `height`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(url, forKey: .url)
        } catch {
            throw InvalidRemoteBitmapImageError(message: "Unable to encode `url`, error: \(error)")
        }
        do {
            try container.encode(imageType, forKey: .imageType)
        } catch {
            throw InvalidRemoteBitmapImageError(message: "Unable to encode `imageType`, error: \(error)")
        }
        do {
            try container.encode(width, forKey: .width)
        } catch {
            throw InvalidRemoteBitmapImageError(message: "Unable to encode `width`, error: \(error)")
        }
        do {
            try container.encode(height, forKey: .height)
        } catch {
            throw InvalidRemoteBitmapImageError(message: "Unable to encode `height`, error: \(error)")
        }
    }
}

public struct InvalidRemoteBitmapImageError: Error {
    public var message: String?
}
