//
//  ShowDetailsTableViewFirstCell.swift
//  TV Shows
//
//  Created by Leo Goršić on 20.02.2022..
//

import UIKit

class ShowDetailsCell: UITableViewCell {


    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }

    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showDescription: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

    override func layoutSubviews() {
        showImage.layer.cornerRadius = 12
    }
    
}

// MARK: - Setup UI -

extension ShowDetailsCell {
    func setUpCellUI(for show: Show) {
        setUpImageView(url: show.imageURL ?? Constants.CommonURL.errorImageURL)
        setUpDescription(description: show.description ?? "No description available")
    }

    private func setUpImageView(url: String) {
        guard let showImageURL = URL(string: url) else { return }
        showImage.loadImageFromNetwork(url: showImageURL)
        print("Postavio sam sliku")
    }

    private func setUpDescription(description: String) {
        showDescription.text = description
        print("Postavio sam opis")
    }
}
