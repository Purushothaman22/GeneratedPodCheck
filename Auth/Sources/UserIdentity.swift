import Foundation
import LeoSwiftRuntime

public struct UserIdentity: Codable, Equatable {
    public var id: String
    public var privileges: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case privileges
    }

    

    public init(
        id: String,
        privileges: [String]
    ) {
        self.id = id
        self.privileges = privileges
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            id = try values.decode(String.self, forKey: .id)
        } catch {
            throw InvalidUserIdentityError(message: "Unable to decode `id`, error: \(error)")
        }
        do {
            privileges = try values.decode([String].self, forKey: .privileges)
        } catch {
            throw InvalidUserIdentityError(message: "Unable to decode `privileges`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(id, forKey: .id)
        } catch {
            throw InvalidUserIdentityError(message: "Unable to encode `id`, error: \(error)")
        }
        do {
            try container.encode(privileges, forKey: .privileges)
        } catch {
            throw InvalidUserIdentityError(message: "Unable to encode `privileges`, error: \(error)")
        }
    }

    
}

public struct InvalidUserIdentityError: Error {
    public var message: String?
    public var error: Error?
}
