import Foundation
import LeoSwiftRuntime

public struct ItemAction: Codable, Equatable {
    public var destinationType: Destination
    public var fallbackAction: FallbackDestination?

    enum CodingKeys: String, CodingKey {
        case destinationType
        case fallbackAction
    }

    public init(
        destinationType: Destination,
        fallbackAction: FallbackDestination?
    ) {
        self.destinationType = destinationType
        self.fallbackAction = fallbackAction
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            destinationType = try values.decode(Destination.self, forKey: .destinationType)
        } catch {
            throw InvalidItemActionError(message: "Unable to decode `destinationType`, error: \(error)")
        }
        do {
            fallbackAction = try values.decodeWithDefault(FallbackDestination?.self, forKey: .fallbackAction, withDefault: nil)
        } catch {
            throw InvalidItemActionError(message: "Unable to decode `fallbackAction`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(destinationType, forKey: .destinationType)
        } catch {
            throw InvalidItemActionError(message: "Unable to encode `destinationType`, error: \(error)")
        }
        do {
            try container.encode(fallbackAction, forKey: .fallbackAction)
        } catch {
            throw InvalidItemActionError(message: "Unable to encode `fallbackAction`, error: \(error)")
        }
    }
}

public struct InvalidItemActionError: Error {
    public var message: String?
}
