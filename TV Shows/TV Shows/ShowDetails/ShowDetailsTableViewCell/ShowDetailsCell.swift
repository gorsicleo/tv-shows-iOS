//
//  ShowDetailsTableViewFirstCell.swift
//  TV Shows
//
//  Created by Leo Goršić on 20.02.2022..
//

import UIKit

final class ShowDetailsCell: UITableViewCell {

    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
    
    @IBOutlet weak var showRatingLabel: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showRating: RatingView!
    @IBOutlet weak var showDescription: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        // I intentionally did not call the method super.layoutSubviews because it will draw separator line
        showImage.layer.cornerRadius = 12
    }
}

// MARK: - Setup UI -

extension ShowDetailsCell {
    func setUpCellUI(for show: Show) {
        setUpImageView(url: show.imageURL ?? Constants.CommonURL.errorImageURL)
        setUpDescription(description: show.description ?? "No description available")
        setUpRatingView(rating: show.averageRating ?? 0)
        setUpRatingLabel(show: show)
    }

    private func setUpRatingLabel(show: Show) {
        showRatingLabel.text = "\(show.numberOfReviews) REVIEWS, \(show.averageRating ?? 0) AVERAGE"
    }

    private func setUpRatingView(rating: Int) {
        showRating.configure(withStyle: .large)
        showRating.isEnabled = false
        showRating.rating = rating
    }

    private func setUpImageView(url: String) {
        guard let showImageURL = URL(string: url) else { return }
        showImage.loadImageFromNetwork(url: showImageURL)
    }

    private func setUpDescription(description: String) {
        showDescription.text = description
    }
}
