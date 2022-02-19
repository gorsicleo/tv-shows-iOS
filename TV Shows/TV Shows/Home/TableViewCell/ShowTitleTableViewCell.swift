//
//  ShowTitleTableViewCell.swift
//  TV Shows
//
//  Created by Leo Goršić on 15.02.2022..
//

import UIKit

final class ShowTitleTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }

    // MARK: - IBOutlets -
    
    @IBOutlet private weak var showTitle: UILabel!
    @IBOutlet private weak var showImage: UIImageView!
    
    // MARK: - Nib Lifecycle -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        showImage.image = nil
    }
}

// MARK: - Setup UI -

extension ShowTitleTableViewCell {
    func setUpCellUI(for show: Show) {
        setUpImageView(url: show.imageURL ?? Constants.CommonURL.errorImageURL)
        setUpTitleLabel(title: show.title)
    }

    private func setUpImageView(url: String) {
        guard let showImageURL = URL(string: url) else { return }
        showImage.loadImageFromNetwork(url: showImageURL)
    }

    private func setUpTitleLabel(title: String) {
        showTitle.text = title
    }
}
