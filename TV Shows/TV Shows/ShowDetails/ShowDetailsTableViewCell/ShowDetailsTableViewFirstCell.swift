//
//  ShowDetailsTableViewFirstCell.swift
//  TV Shows
//
//  Created by Leo Goršić on 20.02.2022..
//

import UIKit

class ShowDetailsTableViewFirstCell: UITableViewCell {


    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }

    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showDescription: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// MARK: - Setup UI -

extension ShowDetailsTableViewFirstCell {
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
