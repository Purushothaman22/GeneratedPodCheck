import Foundation
import LeoSwiftRuntime
import Assets

public struct Account: Codable, Equatable {
    public var accountId: UUID
    public var displayName: String
    public var balance: Amount
    public var homeLayout: HomeLayout

    enum CodingKeys: String, CodingKey {
        case accountId
        case displayName
        case balance
        case homeLayout
    }

    public init(
        accountId: UUID,
        displayName: String,
        balance: Amount,
        homeLayout: HomeLayout
    ) {
        self.accountId = accountId
        self.displayName = displayName
        self.balance = balance
        self.homeLayout = homeLayout
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            accountId = try values.decode(UUID.self, forKey: .accountId)
        } catch {
            throw InvalidAccountError(message: "Unable to decode `accountId`, error: \(error)")
        }
        do {
            displayName = try values.decode(String.self, forKey: .displayName)
        } catch {
            throw InvalidAccountError(message: "Unable to decode `displayName`, error: \(error)")
        }
        do {
            balance = try values.decode(Amount.self, forKey: .balance)
        } catch {
            throw InvalidAccountError(message: "Unable to decode `balance`, error: \(error)")
        }
        do {
            homeLayout = try values.decode(HomeLayout.self, forKey: .homeLayout)
        } catch {
            throw InvalidAccountError(message: "Unable to decode `homeLayout`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(accountId, forKey: .accountId)
        } catch {
            throw InvalidAccountError(message: "Unable to encode `accountId`, error: \(error)")
        }
        do {
            try container.encode(displayName, forKey: .displayName)
        } catch {
            throw InvalidAccountError(message: "Unable to encode `displayName`, error: \(error)")
        }
        do {
            try container.encode(balance, forKey: .balance)
        } catch {
            throw InvalidAccountError(message: "Unable to encode `balance`, error: \(error)")
        }
        do {
            try container.encode(homeLayout, forKey: .homeLayout)
        } catch {
            throw InvalidAccountError(message: "Unable to encode `homeLayout`, error: \(error)")
        }
    }
}

public struct InvalidAccountError: Error {
    public var message: String?
}
