//
//  UserLoginRequest.swift
//  TV Shows
//
//  Created by Leo Goršić on 12.02.2022..
//

import Foundation

struct UserLoginRequest: Encodable {
    let email: String
    let password: String
}
