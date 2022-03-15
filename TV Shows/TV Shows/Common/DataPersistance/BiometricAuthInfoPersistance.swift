//
//  BiometricAuthInfoPersistance.swift
//  TV Shows
//
//  Created by Leo Goršić on 11.03.2022..
//

import Foundation
import KeychainAccess
import FileProvider
import RxSwift
import RxCocoa

final class BiometricAuthInfoPersistance {

    static let savingKey = "RequireBiometrics"
    static let propertyListEncoder = PropertyListEncoder()
    static let propertyListDecoder = PropertyListDecoder()
    static let keychain = Keychain(service: "com.TV-shows.AuthInfo")

    static func setBiometricLoginFlag(to value: Bool) {
        UserDefaults.standard.set(value, forKey: savingKey)
        if value {
            BiometricAuthInfoPersistance.saveCredentials()
        } else {
            BiometricAuthInfoPersistance.removeCredentials()
        }
    }

    static func getBiometricLoginFlag() -> Bool {
        return UserDefaults.standard.bool(forKey: savingKey)
    }

    static func saveCredentials() {

        let authInfo = APIManager.shared.authInfo

        DispatchQueue.global().async {
            let data = try? propertyListEncoder.encode(authInfo)
            guard let savingData = data else { return }
            do {
                try keychain
                    .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
                    .set(NSData(data: savingData) as Data, key: savingKey)
            } catch {}
        }
    }

    static func loadCredentials(_ publishSubject: PublishSubject<Void>) {
        if !BiometricAuthInfoPersistance.getBiometricLoginFlag() { return }
        DispatchQueue.global().async {
            do {
                let retrievedData = try keychain
                    .authenticationPrompt("Authenticate to login")
                    .getData(savingKey)

                guard let retrievedData = retrievedData else { return }
                APIManager.shared.authInfo = try? propertyListDecoder.decode(AuthInfo.self, from: retrievedData)
                publishSubject.onNext(())
            } catch {}
        }
    }

    static func removeCredentials() {
        do {
            try keychain.remove(savingKey)
        } catch {}
    }
}
