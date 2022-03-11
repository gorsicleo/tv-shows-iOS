//
//  AppDelegate.swift
//  TV Shows
//
//  Created by Leo Goršić on 02.02.2022..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let authInfo = AuthInfoPersistance.loadCredentials()
        let nav1 = UINavigationController()

        if authInfo != nil {
            APIManager.shared.authInfo = authInfo
            let storyboard = UIStoryboard(name: "Home", bundle: .main)
            let homeViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
            nav1.viewControllers = [homeViewController]
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: .main)
            let mainView = storyboard.instantiateViewController(withIdentifier: "Login")
            nav1.viewControllers = [mainView]
        }

        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
        return true
    }
}
