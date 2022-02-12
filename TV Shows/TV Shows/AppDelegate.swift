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
        let nav1 = UINavigationController()
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        let mainView = storyboard.instantiateViewController(withIdentifier: "Login")
        nav1.viewControllers = [mainView]
        self.window!.rootViewController = nav1
        self.window?.makeKeyAndVisible()
        return true
    }


}

