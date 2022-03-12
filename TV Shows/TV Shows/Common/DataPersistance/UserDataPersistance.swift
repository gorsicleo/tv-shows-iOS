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
        guard let encoded = try? JSONEncoder().encode(user) else { return }
        UserDefaults.standard.set(encoded, forKey: savingKey)
    }

    static func loadUserData() -> User? {
        guard let data = UserDefaults.standard.data(forKey: savingKey),
              let decoded = try? JSONDecoder().decode(User.self, from: data) else { return nil }
       return decoded
    }

    static func removeUserData() {
        guard let _ = UserDefaults.standard.data(forKey: savingKey) else { return }
        UserDefaults.standard.removeObject(forKey: savingKey)
    }
}
