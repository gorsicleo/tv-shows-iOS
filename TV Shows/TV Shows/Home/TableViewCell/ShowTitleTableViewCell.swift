//
//  ShowTitleTableViewCell.swift
//  TV Shows
//
//  Created by Leo Goršić on 15.02.2022..
//

import UIKit

final class ShowTitleTableViewCell: UITableViewCell {

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
    
    // MARK: - Setup UI -
    
    func setUpCellUI(for show: Show) {
        setUpImageView(url: show.imageURL ?? Constants.CommonURL.errorImageURL)
        setUpTitleLabel(title: show.title)
    }
    
    func setUpImageView(url: String) {
        guard let showImageURL = URL(string: url) else { return }
        showImage.loadImageFromNetwork(url: showImageURL)
    }
    
    func setUpTitleLabel(title: String) {
        showTitle.text = title
    }
    
    override func prepareForReuse() {
        showImage.image = nil
    }
}
