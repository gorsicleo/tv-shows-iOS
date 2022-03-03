//
//  ApiErrorModel.swift
//  TV Shows
//
//  Created by Leo Goršić on 03.03.2022..
//

import Foundation

struct APIError: Decodable {
    let errors: [String]?
}
