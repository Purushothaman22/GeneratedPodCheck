import Foundation
import LeoSwiftRuntime

public struct CornerRadius: Codable, Equatable {
    public var top: Int32
    public var bottom: Int32

    enum CodingKeys: String, CodingKey {
        case top
        case bottom
    }

    public init(
        top: Int32 = 0,
        bottom: Int32 = 0
    ) {
        self.top = top
        self.bottom = bottom
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            top = try values.decodeWithDefault(Int32.self, forKey: .top, withDefault: 0)
        } catch {
            throw InvalidCornerRadiusError(message: "Unable to decode `top`, error: \(error)")
        }
        do {
            bottom = try values.decodeWithDefault(Int32.self, forKey: .bottom, withDefault: 0)
        } catch {
            throw InvalidCornerRadiusError(message: "Unable to decode `bottom`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(top, forKey: .top)
        } catch {
            throw InvalidCornerRadiusError(message: "Unable to encode `top`, error: \(error)")
        }
        do {
            try container.encode(bottom, forKey: .bottom)
        } catch {
            throw InvalidCornerRadiusError(message: "Unable to encode `bottom`, error: \(error)")
        }
    }
}

public struct InvalidCornerRadiusError: Error {
    public var message: String?
}
