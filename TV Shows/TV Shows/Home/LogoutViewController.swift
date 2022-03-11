//
//  LogoutController.swift
//  TV Shows
//
//  Created by Leo Goršić on 11.03.2022..
//

import Foundation
import UIKit

final class LogoutViewController: UIViewController {

    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var changePhotoButton: UIButton!
    @IBOutlet private weak var logoutButton: CustomButton!

    var user: User?


    override func viewDidLoad() {
        if let user = user {
            setUpUI(for: user)
        }
        setUpNavigationBar()
    }
}

private extension LogoutViewController {

    func setUpUI(for user: User) {
        setUpEmailLabel(email: user.email)
        setUpImageView(imageUrl: user.imageUrl)
        setUpButtons()

    }

    func setUpEmailLabel(email: String) {
        emailLabel.text = email
    }

    func setUpImageView(imageUrl: String?) {
        guard let imageUrl = imageUrl else { return }
        imageView.loadImageFromNetwork(url: URL(string: imageUrl)!)
        imageView.makeRounded()
    }

    func setUpButtons() {
        setUpChangePhotoButton()
        setUpLogoutButton()
    }

    func setUpChangePhotoButton() {

    }

    func setUpLogoutButton() {
        logoutButton.setBackgroundColor(Constants.Colors.mainRedColor, for: .normal)
        logoutButton.makeRounded()
    }

    func setUpNavigationBar() {
        title = "My Account"
        addLeftNavigationButton()
    }

    func addLeftNavigationButton() {

        let leftNavigationButton = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(closeButtonClicked(sender:))
        )
        navigationItem.leftBarButtonItem?.tintColor = Constants.Colors.mainRedColor
        navigationItem.setLeftBarButtonItems([leftNavigationButton], animated: false)
    }

    @objc func closeButtonClicked(sender: UIButton){
        dismiss(animated: true)
    }

}

private extension LogoutViewController {

    @IBAction func logoutAction(_ sender: Any) {
        AuthInfoPersistance.removeCredentials()
    }
}
