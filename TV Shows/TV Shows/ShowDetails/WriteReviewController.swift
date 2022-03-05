//
//  WriteReviewController.swift
//  TV Shows
//
//  Created by Leo Goršić on 03.03.2022..
//

import Foundation
import UIKit
import SVProgressHUD

final class WriteReviewController: UIViewController {

    // MARK: - Private properties -

    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet private weak var submitButton: CustomButton!
    @IBOutlet private weak var reviewTextView: UITextView!

    var show: Show?

    var completionHandler: ((Review) -> Void)?


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

// MARK: - IBAction -

private extension WriteReviewController {

    @IBAction func submitButtonAction(_ sender: Any) {
        sendApiCallAddReview(comment: reviewTextView.text, rating: ratingView.rating)
    }
}

// MARK: - API Call -

private extension WriteReviewController {

    func sendApiCallAddReview(comment: String?, rating: Int) {

        guard let showId = show?.id, let showId = Int(showId), let comment = comment else { return }
        SVProgressHUD.show()
        APIManager
            .shared
            .call(router: .createReview(showId: showId, comment: comment, rating: rating), responseType: ReviewResponse.self) { [weak self] response in
                SVProgressHUD.dismiss()
                guard let self = self else { return }

                switch response.result {
                case .success(let payload) :
                    self.handleSuccess(review: payload.review)
                    break;
                case .failure :
                    self.handleFailure(response.data, defaultValue: Constants.AlertMessages.networkError)
                    break
                }
        }
    }
}

private extension WriteReviewController {

    func handleSuccess(review: Review) {
        completionHandler?(review)
        dismiss(animated: true)
    }

    func handleFailure(_ data: Data?, defaultValue: String) {
        let errors = ErrorDecoder.decode(from: data, defaultValue: defaultValue)
        for error in errors {
            SVProgressHUD.showError(withStatus: error)
        }

    }
}
