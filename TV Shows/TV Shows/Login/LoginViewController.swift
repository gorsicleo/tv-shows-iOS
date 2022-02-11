//
//  LoginViewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 02.02.2022..

import UIKit
import Alamofire
import SVProgressHUD

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func segueButtonPressed(_ sender: Any) {
            performSegue(withIdentifier: "goToHome", sender: self)
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
    
    func switchScreen() {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let params: [String: String] = [
            "email": email,
            "password": password,
        ]
        
        sendApiCall(endPoint: .userLogin, params: params)
    }
    
    @IBAction func registerButtonAction(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let params: [String: String] = [
            "email": email,
            "password": password,
            "password_confirmation": password
        ]
        
        sendApiCall(endPoint: .userRegister, params: params)
    }
    
}

// MARK: - API CALL -

private extension LoginViewController {
    
    func sendApiCall(endPoint : EndpointItem, params: Parameters?) {
        SVProgressHUD.show()
        APIManager
            .shared()
            .call(type: endPoint, params: params,responseType: UserResponse.self) {
                response in
                SVProgressHUD.dismiss()
                switch response.result {
                case .success(let payload) :
                    guard let headers = response.response?.headers.dictionary else { return }
                    switch endPoint {
                    case .userLogin:
                        self.handleSuccesfulLogin(for: payload.user,headers: headers)
                        break
                    case .userRegister:
                        self.handleSuccesfulRegister(for: payload.user, headers: headers)
                        break
                    }
                    break;
                case .failure(let error) :
                    switch endPoint {
                    case .userLogin:
                        self.handleFailedLogin(error)
                        break;
                    case .userRegister:
                        self.handleFailedRegister(error)
                        break;
                    }
                    break
                    
                }
        }
    }
}
    
    // MARK: - API RESPONSE HANDLERS -

private extension LoginViewController {
    
    func handleSuccesfulLogin(for user: User, headers: [String: String]) {
        //In future for AuthInfo
        guard let _ = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: Constants.AlertMessages.missingHeaders)
            return
        }
        SVProgressHUD.showSuccess(withStatus: Constants.AlertMessages.loginSuccesful)
        switchScreen()
    }
    
    func handleSuccesfulRegister(for user: User, headers: [String: String]) {
        //In future for AuthInfo
        guard let _ = try? AuthInfo(headers: headers) else {
            SVProgressHUD.showError(withStatus: Constants.AlertMessages.missingHeaders)
            return
        }
        SVProgressHUD.showSuccess(withStatus: Constants.AlertMessages.resgisterSuccesful)
    }
    
    func handleFailedLogin(_ error: AFError) {
        SVProgressHUD.showError(withStatus: Constants.AlertMessages.loginFailed)
    }
    
    func handleFailedRegister(_ error: AFError) {
        SVProgressHUD.showError(withStatus: Constants.AlertMessages.registerFailed)
    }
}


