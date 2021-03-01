import Foundation
import LeoSwiftRuntime

public struct Destination: Codable, Equatable {
    public var destination: String

    enum CodingKeys: String, CodingKey {
        case destination
    }

    public init(
        destination: String
    ) {
        self.destination = destination
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            destination = try values.decode(String.self, forKey: .destination)
        } catch {
            throw InvalidDestinationError(message: "Unable to decode `destination`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(destination, forKey: .destination)
        } catch {
            throw InvalidDestinationError(message: "Unable to encode `destination`, error: \(error)")
        }
    }
}

public struct InvalidDestinationError: Error {
    public var message: String?
}
