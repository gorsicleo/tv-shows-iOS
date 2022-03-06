//
//  ShowDetailsTableViewCell.swift
//  TV Shows
//
//  Created by Leo Goršić on 20.02.2022..
//

import UIKit

final class ReviewCell: UITableViewCell {

    // MARK: - Private properties -

    @IBOutlet private weak var reviewerEmail: UILabel!
    @IBOutlet private weak var reviewerRating: RatingView!
    @IBOutlet private weak var reviewerReview: UILabel!
    @IBOutlet private weak var reviewerIcon: UIImageView!

    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }

    // MARK: - Nib lifecycle -

    override func layoutSubviews() {
        super.layoutSubviews()
        reviewerIcon.makeRounded()
    }
}

// MARK: - Setup UI -

extension ReviewCell {
    func setUpCellUI(for review: Review) {
        setUpReviewerIcon(url: review.user.imageUrl)
        setUpReviewerEmail(email: review.user.email)
        setUpReviewerRating(rating: review.rating)
        setUpReviewerReview(review: review.comment)
    }

    private func setUpReviewerIcon(url: String?) {
        guard let url = url else { return }
        reviewerIcon.loadImageFromNetwork(url: URL(string: url)!)
    }

    private func setUpReviewerEmail(email: String) {
        reviewerEmail.text = email
    }

    private func setUpReviewerRating(rating: Int) {
        reviewerRating.rating = rating
        reviewerRating.isEnabled = false
    }

    private func setUpReviewerReview(review: String) {
        reviewerReview.text = review
    }
}
