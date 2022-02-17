//
//  UIViewControllerExtensions.swift
//  TV Shows
//
//  Created by Leo Goršić on 17.02.2022..
//

import Foundation
import UIKit

extension UIViewController {
    
    func colorNavigationBar(color: UIColor) {
        guard #available(iOS 13.0, *) else { return }
        let navBarAppearance = createNavigationBarAppearance(with: color)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @available(iOS 13.0, *)
    func createNavigationBarAppearance(with color: UIColor) -> UINavigationBarAppearance {
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarApperance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarApperance.backgroundColor = color
        
        return navBarApperance
    }
}
