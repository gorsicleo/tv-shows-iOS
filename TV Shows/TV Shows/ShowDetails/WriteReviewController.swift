//
//  WriteReviewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 03.03.2022..
//

import Foundation
import UIKit

final class WriteReviewController: UIViewController {

    // MARK: - Private properties -

    @IBOutlet private weak var submitButton: CustomButton!
    @IBOutlet private weak var reviewTextView: UITextView!

    // MARK: - ViewController Life Cycle -

    override func viewDidLoad() {
        addGestureRecognier()
        setUpUI()
        reviewTextView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
    }
}

// MARK: - Setup UI -

private extension WriteReviewController {

    func setUpNavigationBar() {
        title = "Write a Review"
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

    func setUpUI() {
        setUpButton()
        setUpTextView()
    }

    func setUpButton() {
        submitButton.setBackgroundColor(Constants.Colors.mainRedColor, for: .normal)
        submitButton.makeRounded()
    }

    func setUpTextView() {
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.backgroundColor = Constants.Colors.textViewBacgroundColor
        setUpPlaceholderText()
    }

    func setUpPlaceholderText() {
        reviewTextView.text = "Enter your comment here"
        reviewTextView.textColor = UIColor.lightGray
    }

    func removePlaceholderText() {
        reviewTextView.text = nil
        reviewTextView.textColor = UIColor.black
    }
}
// MARK: - Setup Text View -

extension WriteReviewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            removePlaceholderText()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setUpPlaceholderText()
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
