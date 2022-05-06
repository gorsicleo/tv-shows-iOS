//
//  AppDelegate.swift
//  TV Shows
//
//  Created by Leo Goršić on 02.02.2022..
//

import UIKit

enum OnBootNavigationOption {
    case home
    case login
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let authInfo = AuthInfoPersistance.loadCredentials()
        let isBiometricsRequired = BiometricAuthInfoPersistance.getBiometricLoginFlag()

        guard authInfo != nil else { navigate(to: .login); return true}
        if isBiometricsRequired {
            navigate(to: .login)
        } else {
            APIManager.shared.authInfo = authInfo
            navigate(to: .home)
        }

        window?.makeKeyAndVisible()
        return true
    }
}

private extension AppDelegate {

    func navigate(to navigationOption: OnBootNavigationOption) {
        let baseNavigationController = UINavigationController()

        switch navigationOption {
        case .login:
            let storyboard = UIStoryboard(name: "Login", bundle: .main)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            baseNavigationController.viewControllers = [loginViewController]
            window!.rootViewController = baseNavigationController

        case .home:
            let storyboard = UIStoryboard(name: "Home", bundle: .main)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            baseNavigationController.viewControllers = [homeViewController]
            window!.rootViewController = baseNavigationController
        }
    }
}
