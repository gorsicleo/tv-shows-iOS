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
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let authInfo = AuthInfoPersistance.loadCredentials()
        let isBiometricsRequired = BiometricAuthInfoPersistance.getBiometricLoginFlag()


        if authInfo != nil {
            if isBiometricsRequired {
                navigate(to: .login)
            } else {
                APIManager.shared.authInfo = authInfo
                navigate(to: .home)
            }
        } else {
            navigate(to: .login)
        }

        self.window?.makeKeyAndVisible()
        return true
    }
}

private extension AppDelegate {

    func navigate(to navigationOption: OnBootNavigationOption) {
        let nav1 = UINavigationController()

        switch navigationOption {
        case .login:
            let storyboard = UIStoryboard(name: "Login", bundle: .main)
            let mainView = storyboard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            nav1.viewControllers = [mainView]
            self.window!.rootViewController = nav1

        case .home:
            let storyboard = UIStoryboard(name: "Home", bundle: .main)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            nav1.viewControllers = [homeViewController]
            self.window!.rootViewController = nav1
        }
    }
}
