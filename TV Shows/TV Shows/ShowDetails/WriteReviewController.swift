//
//  WriteReviewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 03.03.2022..
//

import Foundation
import UIKit

final class WriteReviewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var submitButton: CustomButton!
    @IBOutlet weak var reviewTextField: UITextView!

    override func viewDidLoad() {
        addGestureRecognier()
        submitButton.setBackgroundColor(Constants.Colors.mainRedColor, for: .normal)
        submitButton.makeRounded()
        reviewTextField.layer.cornerRadius = 10
        reviewTextField.backgroundColor = Constants.Colors.textViewBacgroundColor
        reviewTextField.text = "Enter your comment here"
        reviewTextField.textColor = UIColor.lightGray
        reviewTextField.delegate = self


    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your comment here"
            textView.textColor = UIColor.lightGray
        }
    }

    func addGestureRecognier() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
}
