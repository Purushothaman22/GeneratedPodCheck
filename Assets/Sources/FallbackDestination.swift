import Foundation
import LeoSwiftRuntime

public struct FallbackDestination: Codable, Equatable {
    public var destination: URL

    enum CodingKeys: String, CodingKey {
        case destination
    }

    public init(
        destination: URL
    ) {
        self.destination = destination
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            destination = try values.decode(URL.self, forKey: .destination)
        } catch {
            throw InvalidFallbackDestinationError(message: "Unable to decode `destination`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(destination, forKey: .destination)
        } catch {
            throw InvalidFallbackDestinationError(message: "Unable to encode `destination`, error: \(error)")
        }
    }
}

public struct InvalidFallbackDestinationError: Error {
    public var message: String?
}
