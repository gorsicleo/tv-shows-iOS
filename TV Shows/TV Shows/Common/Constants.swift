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
        static let textViewBacgroundColor = UIColor(rgb: 0xf2f2f2)
        static let mainRedColor = UIColor(rgb: 0x800000)
        static let disabledMainColor = UIColor(rgb: 0xaf4141)
        static let disabledTitleColor = UIColor(rgb: 0xc4c4c4)
        static let navigationBarLightGray = UIColor(displayP3Red: 249/255, green: 249/255, blue: 249/255, alpha: 0.94)
    }
    
    // MARK: - Alert messages -
    
    enum AlertMessages {
        static let loginSuccesful = "Login successful"
        static let resgisterSuccesful = "Register success. Log in to continue."
        static let missingHeaders = "Missing headers"
        static let networkError = "Can't connect to the server. Please check your connection"
    }
    
    // MARK: - URL-s -
    
    enum CommonURL {
        static let errorImageURL = "https://www.iconpacks.net/icons/1/free-error-icon-905-thumb.png"
    }
}
