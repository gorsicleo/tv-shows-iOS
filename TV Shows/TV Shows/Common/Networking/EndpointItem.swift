//
//  EndpointItem.swift
//  TV Shows
//
//  Created by Leo Goršić on 08.02.2022..
//

import Alamofire

enum EndpointItem {
    
    // MARK: - User actions -
    
    case userLogin
    case userRegister
}

// MARK: - Extensions -

// MARK: - EndPointType -

extension EndpointItem: EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String {
        return "https://tv-shows.infinum.academy"
    }
    
    var path: String {
        switch self {
        case .userLogin:
            return "/users/sign_in"
        case .userRegister:
            return "/users"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .userLogin, .userRegister:
            return .post
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        default:
            return JSONEncoding.default
        }
    }
}
