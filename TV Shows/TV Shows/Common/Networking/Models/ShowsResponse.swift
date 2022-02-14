//
//  ShowsResponse.swift
//  TV Shows
//
//  Created by Leo Goršić on 13.02.2022..
//

import Foundation

struct ShowsResponse: Decodable {
    let shows: [Show]
    // pagination metadata (optional, only needed for extra)
}
