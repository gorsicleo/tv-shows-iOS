//
//  AlertService.swift
//  TV Shows
//
//  Created by Leo Goršić on 12.03.2022..
//  Credits: 2019 Alex Nagy

import Foundation
import UIKit

extension UIViewController {

    func showAlert(style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .cancel, handler: nil)], completion: (() -> Swift.Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}

