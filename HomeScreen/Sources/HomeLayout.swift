import Foundation
import LeoSwiftRuntime
import Assets

public struct HomeLayout: Codable, Equatable {
    public var backgroundImageURL: Assets.ThemedImage
    public var sections: [Assets.LayoutSection]

    enum CodingKeys: String, CodingKey {
        case backgroundImageURL
        case sections
    }

    public init(
        backgroundImageURL: Assets.ThemedImage,
        sections: [Assets.LayoutSection]
    ) {
        self.backgroundImageURL = backgroundImageURL
        self.sections = sections
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            backgroundImageURL = try values.decode(Assets.ThemedImage.self, forKey: .backgroundImageURL)
        } catch {
            throw InvalidHomeLayoutError(message: "Unable to decode `backgroundImageURL`, error: \(error)")
        }
        do {
            sections = try values.decode([Assets.LayoutSection].self, forKey: .sections)
        } catch {
            throw InvalidHomeLayoutError(message: "Unable to decode `sections`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(backgroundImageURL, forKey: .backgroundImageURL)
        } catch {
            throw InvalidHomeLayoutError(message: "Unable to encode `backgroundImageURL`, error: \(error)")
        }
        do {
            try container.encode(sections, forKey: .sections)
        } catch {
            throw InvalidHomeLayoutError(message: "Unable to encode `sections`, error: \(error)")
        }
    }
}

public struct InvalidHomeLayoutError: Error {
    public var message: String?
}
