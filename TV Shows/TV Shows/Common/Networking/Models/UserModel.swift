//
//  UserModel.swift
//  TV Shows
//
//  Created by Leo Goršić on 09.02.2022..
//

import Foundation

struct User: Codable {
    let email: String
    let imageUrl: String?
    let id: String

    enum CodingKeys: String, CodingKey {
        case email
        case imageUrl = "image_url"
        case id
    }
}
