//
//  ShowsResponse.swift
//  TV Shows
//
//  Created by Leo Goršić on 13.02.2022..
//

import Foundation

struct ShowsResponse: Decodable {
    let shows: [Show]
    let meta: Meta
}

struct TopRatedResponse: Decodable {
    let shows: [Show]
}

struct ShowDetailsResponse: Decodable {
    let show: Show
}

// pagination metadata (optional, only needed for extra)

struct Meta: Decodable {
    let pagination: Pagination
}

struct Pagination: Decodable {
    let count: Int
    let page: Int
    let items: Int
    let pages: Int
}
