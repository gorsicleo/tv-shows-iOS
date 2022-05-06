//
//  ShowModel.swift
//  TV Shows
//
//  Created by Leo Goršić on 13.02.2022..
//

import Foundation

struct Show: Decodable {
    
    let id: String
    let description: String?
    let imageURL: String?
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case imageURL = "image_url"
        case title
    }
}

