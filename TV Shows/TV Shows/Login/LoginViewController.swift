//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 02.02.2022..

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Private Properties -
    
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var passwordVisibilityButton: UIButton!
    @IBOutlet private weak var loginButton: CustomButton!
    @IBOutlet private weak var registerButton: UIButton!
    
    // MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        addGestureRecognier()
        
        #if DEBUG
        emailTextField.text = "marko.cupic@fer.hr"
        passwordTextField.text = "supermarko"
        #endif
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpCornerRadius()
    }
}

// MARK: - Extensions -

// MARK: - Setup UI -

private extension LoginViewController {
    
    func setUpUI() {
        setUpTextFields()
        setUpPasswordVisibilityButton()
        setUpRememberMeButton()
        setUpLoginButton()
    }
    
    func setUpTextFields() {
        setUpEmailTextField()
        setUpPasswordTextField()
    }
    
    
    func setUpEmailTextField() {
        setWhiteTextColor(for: emailTextField, with: "Email")
        removeTextFieldBorder(for: emailTextField)
    }
    
    func setUpPasswordTextField() {
        setWhiteTextColor(for: passwordTextField, with: "Password")
        removeTextFieldBorder(for: passwordTextField)
    }
    
    func removeTextFieldBorder(for textField: UITextField) {
        textField.borderStyle = .none
    }
    
    func setWhiteTextColor(for textField: UITextField, with placeholderText: String) {
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    
    func setUpRememberMeButton() {
        rememberMeButton.setImage(Constants.Buttons.rememberMeButtonUnchecked, for: .normal)
        rememberMeButton.setImage(Constants.Buttons.rememberMeButtonChecked, for: .selected)
    }
    
    func setUpPasswordVisibilityButton() {
        passwordVisibilityButton.setImage(Constants.Buttons.visibilityEnabled, for: .normal)
        passwordVisibilityButton.setImage(Constants.Buttons.visibilityDisabled, for: .selected)
    }
    
    func setUpLoginButton() {
        setUpLoginButtonBackgroundColor()
        setUpLoginButtonTextColor()
        loginButton.isEnabled = false
    }
    
    func setUpLoginButtonBackgroundColor() {
        loginButton.setBackgroundColor(.white, for: .normal)
        loginButton.setBackgroundColor(Constants.Colors.disabledMainColor, for: .disabled)
    }
    
    func setUpLoginButtonTextColor() {
        loginButton.setTitleColor(Constants.Colors.disabledTitleColor, for: .disabled)
        loginButton.setTitleColor(Constants.Colors.mainRedColor, for: .normal)
    }

    func checkInputValidity() {
        guard let emailFieldInput = emailTextField.text else { return }
        guard let passwordFieldInput = passwordTextField.text else { return }

        loginButton.isEnabled = emailFieldInput.count > 0 && passwordFieldInput.count > 0 ? true : false
    }
    
    func addGestureRecognier() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpCornerRadius() {
        loginButton.layer.cornerRadius = Constants.Buttons.buttonCornerRadius
    }
}

// MARK: - IBAction -

private extension LoginViewController {
    
    @IBAction func passwordVisibilityAction() {
        passwordTextField.isSecureTextEntry.toggle()
        passwordVisibilityButton.isSelected.toggle()
    }
    
    @IBAction func rememberMeAction() {
        rememberMeButton.isSelected.toggle()
    }
    
    @IBAction func emailFieldValueChangeAction() {
        checkInputValidity()
    }
    
    @IBAction func passwordFieldValueChangeAction() {
        checkInputValidity()
    }
}
