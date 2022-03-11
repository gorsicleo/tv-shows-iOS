//
//  UserDataPersistance.swift
//  TV Shows
//
//  Created by Leo Goršić on 11.03.2022..
//

import Foundation

final class UserDataPersistance {

    private static let savingKey: String = "UserInfo"

    static func saveUserData(for user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encoded, forKey: savingKey)
            }
    }

    static func loadUserData() -> User? {
        if let data = UserDefaults.standard.data(forKey: savingKey),
            let decoded = try? JSONDecoder().decode(User.self, from: data) {
                return decoded
            }
        return nil
    }
}
