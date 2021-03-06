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

    @IBOutlet private weak var ratingView: RatingView!
    @IBOutlet private weak var submitButton: CustomButton!
    @IBOutlet private weak var reviewTextView: UITextView!
    @IBOutlet private weak var scrollView: UIScrollView!
    private var notificationTokens: [NSObjectProtocol] = []

    // MARK: - public properties -

    var show: Show?
    var completionHandler: ((Review) -> Void)?

    // MARK: - ViewController Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        handleKeyboard()
        setUpUI()
    }

    deinit {
        notificationTokens.forEach(NotificationCenter.default.removeObserver)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpCornerRadius()
    }

}

// MARK: - Setup UI -

private extension WriteReviewController {

    func handleKeyboard() {
        let showToken = createKeyboardWillShowToken()
        notificationTokens.append(showToken)

        let hideToken = createKeyboardWillHideToken()
        notificationTokens.append(hideToken)
    }

    func createKeyboardWillShowToken() -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil) { [unowned self] notification in
                guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                let height = value.cgRectValue.size.height
                scrollView.contentInset.bottom = height
                scrollView.scrollIndicatorInsets.bottom = height
        }
    }

    func createKeyboardWillHideToken() -> NSObjectProtocol{
        return NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil) { [unowned self] notification in
                scrollView.contentInset.bottom = 0
                scrollView.scrollIndicatorInsets.bottom = 0
            }
    }

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
    }

    func setUpTextView() {
        reviewTextView.delegate = self
        reviewTextView.backgroundColor = Constants.Colors.textViewBacgroundColor
        setUpPlaceholderText()
    }

    func setUpCornerRadius() {
        reviewTextView.layer.cornerRadius = 10
        submitButton.makeRounded()
    }

    func setUpPlaceholderText() {
        reviewTextView.text = "Enter your comment here..."
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
}

// MARK: - IBAction -

private extension WriteReviewController {

    @IBAction func submitButtonAction(_ sender: Any) {
        let comment = reviewTextView.text == "Enter your comment here..." ? "" : reviewTextView.text
        sendApiCallAddReview(comment: comment, rating: ratingView.rating)
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

// MARK: - API Response Handlers -

private extension WriteReviewController {

    func handleSuccess(review: Review) {
        completionHandler?(review)
        dismiss(animated: true)
    }

    func handleFailure(_ data: Data?, defaultValue: String) {
        let errors = ErrorDecoder.decode(from: data, defaultValue: defaultValue)
        errors.forEach { SVProgressHUD.showError(withStatus: $0) }
    }
}
