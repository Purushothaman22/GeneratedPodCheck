import Foundation
import LeoSwiftRuntime

public struct Item: Codable, Equatable {
    public var title: LocalizedText?
    public var imageURL: LocalizedImage?
    public var action: ItemAction

    enum CodingKeys: String, CodingKey {
        case title
        case imageURL
        case action
    }

    public init(
        title: LocalizedText?,
        imageURL: LocalizedImage?,
        action: ItemAction
    ) {
        self.title = title
        self.imageURL = imageURL
        self.action = action
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            title = try values.decodeWithDefault(LocalizedText?.self, forKey: .title, withDefault: nil)
        } catch {
            throw InvalidItemError(message: "Unable to decode `title`, error: \(error)")
        }
        do {
            imageURL = try values.decodeWithDefault(LocalizedImage?.self, forKey: .imageURL, withDefault: nil)
        } catch {
            throw InvalidItemError(message: "Unable to decode `imageURL`, error: \(error)")
        }
        do {
            action = try values.decode(ItemAction.self, forKey: .action)
        } catch {
            throw InvalidItemError(message: "Unable to decode `action`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(title, forKey: .title)
        } catch {
            throw InvalidItemError(message: "Unable to encode `title`, error: \(error)")
        }
        do {
            try container.encode(imageURL, forKey: .imageURL)
        } catch {
            throw InvalidItemError(message: "Unable to encode `imageURL`, error: \(error)")
        }
        do {
            try container.encode(action, forKey: .action)
        } catch {
            throw InvalidItemError(message: "Unable to encode `action`, error: \(error)")
        }
    }
}

public struct InvalidItemError: Error {
    public var message: String?
}
