//
//  Router.swift
//  TV Shows
//
//  Created by Leo Goršić on 12.02.2022..
//

import Foundation
import Alamofire

enum Router {

    case login(email: String, password: String)
    case register(email: String, password: String)
    case shows(items: Int, page: Int)
    case topRated
    case reviews(showId: String)
    case createReview(showId: Int, comment: String, rating: Int)
    case userInfo
    case updateProfile(data: MultipartFormData)
    case displayShow(showId: String)

    var path: String {
        switch self {
        case .login:
            return "/users/sign_in"
        case .register, .updateProfile:
            return "/users"
        case .shows:
            return "/shows"
        case .reviews(let showId):
            return "/shows/\(showId)/reviews"
        case .createReview:
            return "/reviews"
        case .userInfo:
            return "/users/me"
        case .topRated:
            return "/shows/top_rated"
        case .displayShow(showId: let showId):
            return "/shows/\(showId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login, .register, .createReview:
            return .post
        case .shows, .reviews, .userInfo, .topRated, .displayShow:
            return .get
        default:
            return .put
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return UserLoginRequest(email: email, password: password).encode()
        case .register(let email, let password):
            return UserRegisterRequest(email: email, password: password).encode()
        case .shows(let items, let page):
            return ["page": page, "items": items]
        case .createReview(let showId, let comment, let rating):
            return ["show_id": showId, "comment": comment, "rating": rating]
        default:
            return [:]
        }
    }

    var data: MultipartFormData? {
        switch self {
        case .updateProfile(let data):
            return data
        default:
            return nil
        }
    }

    var baseURL: URL {
        return URL(string: "https://tv-shows.infinum.academy")!
    }

}

// MARK: Enodable encode extension -

extension Encodable {

    func encode(encoder: JSONEncoder = .init()) -> [String: Any] {
        guard
            let data = try? encoder.encode(self),
            let json = try? JSONSerialization.jsonObject(with: data),
            let dict = json as? [String: Any]
        else {
            return [:]
        }
        return dict
    }
    
}

// MARK: - URLRequestConvertible -

extension Router: URLRequestConvertible {

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        let headers = APIManager.shared.authInfo?.headers ?? [:]
        var request = try URLRequest(url: url, method: method, headers: HTTPHeaders(headers))
        switch method {
        case .post, .put:
            request = try JSONEncoding.default.encode(request, with: parameters)
        default:
            request = try URLEncoding.default.encode(request, with: parameters)
        }
        return request
    }

}
