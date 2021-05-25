//
// Copyright © 2020 Surya Software Systems Pvt. Ltd.
//

import Foundation
import libPhoneNumber_iOS

/// Stores a validated and normalized phone number.
public struct PhoneNumber: Codable, Equatable, Hashable {
    public var value: String

    public init(_ phoneNumber: String, validRegions: [String] = []) throws {
        let cleaned = phoneNumber
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
        var parsed: NBPhoneNumber
        let phoneNumberUtil = NBPhoneNumberUtil()
        do {
            parsed = try phoneNumberUtil.parse(cleaned, defaultRegion: nil)
        } catch {
            throw PhoneNumberError.invalidPhoneNumber("Phone number \(phoneNumber) is invalid", error: error)
        }
        if !phoneNumberUtil.isValidNumber(parsed) {
            throw PhoneNumberError.invalidPhoneNumber("Phone number \(phoneNumber) is invalid")
        }
        if !cleaned.starts(with: "+") {
            throw PhoneNumberError.invalidPhoneNumber("Phone number \(phoneNumber) does not start with a +")
        }
        if !validRegions.isEmpty {
            let validRegionCodes: [NSNumber] = try validRegions.map { region in
                if let regionCode = phoneNumberUtil.getCountryCode(forRegion: region), regionCode != 0 {
                    return regionCode
                }
                throw PhoneNumberError.invalidPhoneNumber("Invalid region code \(region) in \(validRegions)")
            }
            if !validRegionCodes.contains(parsed.countryCode) {
                throw PhoneNumberError.invalidPhoneNumber("Phone number $phoneNumber is invalid")
            }
        }
        value = cleaned
    }
}

public enum PhoneNumberError: Error {
    case invalidPhoneNumber(_ message: String?, error: Error? = nil)
}
