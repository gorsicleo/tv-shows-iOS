//
//  Constants.swift
//  TV Shows
//
//  Created by Leo Goršić on 05.02.2022..
//
import UIKit

enum Constants {
    
    // MARK: - Buttons -
    
    enum Buttons {
        static let visibilityEnabled = UIImage(named: "VisibilityIconEnabled")
        static let visibilityDisabled = UIImage(named: "VisibilityIconDisabled")
        static let rememberMeButtonUnchecked = UIImage(named: "ic-checkbox-unselected")
        static let rememberMeButtonChecked = UIImage(named: "ic-checkbox-selected")
        static let buttonCornerRadius = 18.0
    }
    
    // MARK: - Colors-
    
    enum Colors {
        static let mainRedColor = UIColor(rgb: 0x800000)
        static let disabledMainColor = UIColor(rgb: 0xaf4141)
        static let disabledTitleColor = UIColor(rgb: 0xc4c4c4)
    }
    
    // MARK: - Alert messages -
    
    enum AlertMessages {
        static let loginFailed = "Login failed: Please check your email and password."
        static let loginSuccesful = "Login successful"
        static let resgisterSuccesful = "Register success. Log in to continue."
        static let registerFailed = "Registration failed. Please use different email."
        static let missingHeaders = "Missing headers"
    }
}
