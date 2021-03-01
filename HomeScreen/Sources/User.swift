import Foundation
import LeoSwiftRuntime
import Assets

public struct User: Codable, Equatable {
    public var firstName: String
    public var lastName: String?
    public var otherNames: String?
    public var phoneNumber: LeoSwiftRuntime.PhoneNumber?
    public var emailId: LeoSwiftRuntime.EmailId?
    public var dateOfBirth: Date?
    public var profileImageURL: URL?
    public var selectedAccountId: UUID
    public var canCreateAccount: Bool

    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case otherNames
        case phoneNumber
        case emailId
        case dateOfBirth
        case profileImageURL
        case selectedAccountId
        case canCreateAccount
    }

    public init(
        firstName: String,
        lastName: String?,
        otherNames: String?,
        phoneNumber: LeoSwiftRuntime.PhoneNumber?,
        emailId: LeoSwiftRuntime.EmailId?,
        dateOfBirth: Date?,
        profileImageURL: URL?,
        selectedAccountId: UUID,
        canCreateAccount: Bool
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.otherNames = otherNames
        self.phoneNumber = phoneNumber
        self.emailId = emailId
        self.dateOfBirth = dateOfBirth
        self.profileImageURL = profileImageURL
        self.selectedAccountId = selectedAccountId
        self.canCreateAccount = canCreateAccount
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            firstName = try values.decode(String.self, forKey: .firstName)
        } catch {
            throw InvalidUserError(message: "Unable to decode `firstName`, error: \(error)")
        }
        do {
            lastName = try values.decodeWithDefault(String?.self, forKey: .lastName, withDefault: nil)
        } catch {
            throw InvalidUserError(message: "Unable to decode `lastName`, error: \(error)")
        }
        do {
            otherNames = try values.decodeWithDefault(String?.self, forKey: .otherNames, withDefault: nil)
        } catch {
            throw InvalidUserError(message: "Unable to decode `otherNames`, error: \(error)")
        }
        do {
            phoneNumber = try values.decodeWithDefault(LeoSwiftRuntime.PhoneNumber?.self, forKey: .phoneNumber, withDefault: nil)
        } catch {
            throw InvalidUserError(message: "Unable to decode `phoneNumber`, error: \(error)")
        }
        do {
            emailId = try values.decodeWithDefault(LeoSwiftRuntime.EmailId?.self, forKey: .emailId, withDefault: nil)
        } catch {
            throw InvalidUserError(message: "Unable to decode `emailId`, error: \(error)")
        }
        do {
            dateOfBirth = try values.decodeWithDefault(Date?.self, forKey: .dateOfBirth, withDefault: nil)
        } catch {
            throw InvalidUserError(message: "Unable to decode `dateOfBirth`, error: \(error)")
        }
        do {
            profileImageURL = try values.decodeWithDefault(URL?.self, forKey: .profileImageURL, withDefault: nil)
        } catch {
            throw InvalidUserError(message: "Unable to decode `profileImageURL`, error: \(error)")
        }
        do {
            selectedAccountId = try values.decode(UUID.self, forKey: .selectedAccountId)
        } catch {
            throw InvalidUserError(message: "Unable to decode `selectedAccountId`, error: \(error)")
        }
        do {
            canCreateAccount = try values.decode(Bool.self, forKey: .canCreateAccount)
        } catch {
            throw InvalidUserError(message: "Unable to decode `canCreateAccount`, error: \(error)")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(firstName, forKey: .firstName)
        } catch {
            throw InvalidUserError(message: "Unable to encode `firstName`, error: \(error)")
        }
        do {
            try container.encode(lastName, forKey: .lastName)
        } catch {
            throw InvalidUserError(message: "Unable to encode `lastName`, error: \(error)")
        }
        do {
            try container.encode(otherNames, forKey: .otherNames)
        } catch {
            throw InvalidUserError(message: "Unable to encode `otherNames`, error: \(error)")
        }
        do {
            try container.encode(phoneNumber, forKey: .phoneNumber)
        } catch {
            throw InvalidUserError(message: "Unable to encode `phoneNumber`, error: \(error)")
        }
        do {
            try container.encode(emailId, forKey: .emailId)
        } catch {
            throw InvalidUserError(message: "Unable to encode `emailId`, error: \(error)")
        }
        do {
            try container.encode(dateOfBirth, forKey: .dateOfBirth)
        } catch {
            throw InvalidUserError(message: "Unable to encode `dateOfBirth`, error: \(error)")
        }
        do {
            try container.encode(profileImageURL, forKey: .profileImageURL)
        } catch {
            throw InvalidUserError(message: "Unable to encode `profileImageURL`, error: \(error)")
        }
        do {
            try container.encode(selectedAccountId, forKey: .selectedAccountId)
        } catch {
            throw InvalidUserError(message: "Unable to encode `selectedAccountId`, error: \(error)")
        }
        do {
            try container.encode(canCreateAccount, forKey: .canCreateAccount)
        } catch {
            throw InvalidUserError(message: "Unable to encode `canCreateAccount`, error: \(error)")
        }
    }
}

public struct InvalidUserError: Error {
    public var message: String?
}
