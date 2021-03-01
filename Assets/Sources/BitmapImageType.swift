import Foundation
import LeoSwiftRuntime

public struct BitmapImageType: Codable, Equatable {
    public var JPG: String

    enum CodingKeys: String, CodingKey {
        case JPG
    }

    public init(
        JPG: String
    ) {
        self.JPG = JPG
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            JPG = try values.decode(String.self, forKey: .JPG)
        } catch {
            throw InvalidBitmapImageTypeError(message: "Unable to decode `JPG`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(JPG, forKey: .JPG)
        } catch {
            throw InvalidBitmapImageTypeError(message: "Unable to encode `JPG`, error: \(error)")
        }
    }
}

public struct InvalidBitmapImageTypeError: Error {
    public var message: String?
}
