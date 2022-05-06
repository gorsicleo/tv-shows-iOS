//
//  TabBarNavigationController.swift
//  TV Shows
//
//  Created by Leo Goršić on 15.02.2022..
//

import Foundation
import UIKit

final class TabBarNavigationController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
