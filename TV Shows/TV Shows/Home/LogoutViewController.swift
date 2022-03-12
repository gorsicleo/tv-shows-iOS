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
    @IBOutlet private weak var biometricsSwitch: UISwitch!
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
        setUpBiometricsSwitch()

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

    func setUpBiometricsSwitch() {
        biometricsSwitch.isOn = BiometricAuthInfoPersistance.getBiometricLoginFlag()
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

// MARK: - IBAction -

private extension LogoutViewController {

    @IBAction func logoutAction(_ sender: Any) {
        AuthInfoPersistance.removeCredentials()
        UserDataPersistance.removeUserData()
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        let mainView = storyboard.instantiateViewController(withIdentifier: "Login")
        self.navigationController?.setViewControllers([mainView], animated: true)
    }

    @IBAction func biometricSwitch(_ sender: Any) {
        print(biometricsSwitch.isOn)
        BiometricAuthInfoPersistance.setBiometricLoginFlag(to: biometricsSwitch.isOn)
    }

    @IBAction func changeProfilePictureAction(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }

}

extension LogoutViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func showImagePickerControllerActionSheet() {
        let photoLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        AlertService.showAlert(style: .actionSheet, title: "Choose your image", message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }

    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = originalImage
        }

        dismiss(animated: true, completion: nil)
    }
}
