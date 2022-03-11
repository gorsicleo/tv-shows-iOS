//
//  AuthInfoPersistance.swift
//  TV Shows
//
//  Created by Leo Goršić on 11.03.2022..
//

import Foundation
import KeychainAccess

final class AuthInfoPersistance {

    static let propertyListEncoder = PropertyListEncoder()
    static let propertyListDecoder = PropertyListDecoder()
    static let keychain = Keychain(service: "com.TV-shows.AuthInfo")

    static func saveCredentials() {

        let authInfo = APIManager.shared.authInfo

        let data = try? propertyListEncoder.encode(authInfo)
        if let savingData = data {
            keychain[data: "encodedAuthInfo"] = NSData(data: savingData) as Data
        }

    }

    static func loadCredentials() -> AuthInfo? {
        guard let retrievedData = keychain[data: "encodedAuthInfo"] else { return nil }
        let data = try? propertyListDecoder.decode(AuthInfo.self, from: retrievedData)
        return data
    }

    static func removeCredentials() {
        keychain["encodedAuthInfo"] = nil
    }
}
