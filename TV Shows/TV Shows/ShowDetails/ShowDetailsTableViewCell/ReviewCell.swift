//
//  ShowDetailsTableViewCell.swift
//  TV Shows
//
//  Created by Leo Goršić on 20.02.2022..
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var reviewerEmail: UILabel!
    @IBOutlet weak var reviewerRating: RatingView!
    @IBOutlet weak var reviewerReview: UILabel!
    @IBOutlet weak var reviewerIcon: UIImageView!

    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
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
    }

    private func setUpReviewerReview(review: String) {
        reviewerReview.text = review
    }


}
