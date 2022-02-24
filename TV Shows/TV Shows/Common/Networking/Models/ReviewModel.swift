//
//  ReviewModel.swift
//  TV Shows
//
//  Created by Leo Goršić on 21.02.2022..
//

import Foundation

struct ReviewsResponse: Decodable {
    let reviews: [Review]
}

struct ReviewResponse: Decodable {
    let review: Review
}

struct Review: Decodable {
    let id: String
    let comment: String
    let rating: Int
    let showId: Int
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case comment
        case rating
        case showId = "show_id"
        case user
    }
}
