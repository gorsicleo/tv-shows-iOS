//
//  UIImageViewExtensions.swift
//  TV Shows
//
//  Created by Leo Goršić on 17.02.2022..
//

import Foundation
import UIKit

// MARK: - UIImageView -

extension UIImageView {
    
    func loadImageFromNetwork(url: URL) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    }

    func makeRounded() {
        layer.cornerRadius = frame.size.width / 2
    }
}
