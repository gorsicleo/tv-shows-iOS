//
//  ApiManager.swift
//  TV Shows
//
//  Created by Leo Goršić on 09.02.2022..
//

import Alamofire
import UIKit

protocol APIManagerInterface {
    var authInfo: AuthInfo? { get set }
    func call<T>(
        router: Router,
        responseType: T.Type,
        handler: @escaping (DataResponse<T,AFError>)->()
    ) where T : Decodable

}

/// ` APIManager` represens singleton instance for managing API requests. 
final class APIManager: APIManagerInterface {
    
    static let shared = APIManager(session: Session())
    private let session: Session
    var authInfo: AuthInfo?
    
    private init(session: Session) {
        self.session = session
    }
    // MARK: - Methods -
    
    /// Creates a `DataRequest` from a `URLRequest` created using the passed components and a `RequestInterceptor`.
    ///
    /// - Parameters:
    ///   - type:            `EndPointType` value to be used as the `URLRequest`'s `URL`.
    ///   - params:          `Parameters` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default.
    ///   - responseType:    `T.type` class type used for inferring generic parameter `T`
    ///   - handler:         `closure DataResponse<T, AFError> -> Void` that will be called after response is recieved. Used for defining further response processing.
    ///
    func call<T>(
        router: Router,
        responseType: T.Type,
        handler: @escaping (DataResponse<T,AFError>)->()
    ) where T : Decodable {
        switch router {
        case .updateProfile:
            guard let data = router.data else { return }
            session
                .upload(multipartFormData: data, with: router)
                .validate()
                .responseDecodable(of: T.self) {
                    handler($0)
                }
        default:
            session
                .request(router)
                .validate()
                .responseDecodable(of: T.self) {
                    handler($0)
                }
        }

    }

    static func createMultipartDataFromImage(image: UIImage) -> MultipartFormData? {
        guard let imageData = image.jpegData(compressionQuality: 1) else { return nil}
        let multipartFormData = MultipartFormData()
        multipartFormData.append(
                    imageData,
                    withName: "image",
                    fileName: "image.jpg",
                    mimeType: "image/jpg"
        )
        return multipartFormData
    }
}

final class ErrorDecoder {

    static func decode(from response: Data?, defaultValue: String) -> [String] {
            guard let response = response else { return [] }
            let decoder = JSONDecoder()
            do {
                let error = try decoder.decode(APIError.self, from: response)
                return error.errors ?? [defaultValue]
            } catch {
                return [defaultValue]
            }
        }
}

struct AuthInfo: Codable {

    let accessToken: String
    let client: String
    let tokenType: String
    let expiry: String
    let uid: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
        case client = "client"
        case tokenType = "token-type"
        case expiry = "expiry"
        case uid = "uid"
    }

    // MARK: Helpers
    
    init(headers: [String: String]) throws {
        let data = try JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

    var headers: [String: String] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            return jsonObject as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }
}
