//
//  ApiManager.swift
//  TV Shows
//
//  Created by Leo Goršić on 09.02.2022..
//

import Alamofire

/// ` APIManager` represens singleton instance for managing API requests. 
final class APIManager {
    
    // MARK: - Vars & Lets -
    
    private let session: Session
    
    // MARK: - Vars & Lets -
    
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(session: Session())
        return apiManager
    }()
    
    // MARK: - Accessors -
    
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    // MARK: - Initialization -
    
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
    func call<T>(type: EndPointType, params: Parameters? = nil,responseType: T.Type, handler: @escaping (DataResponse<T,AFError>)->()) where T : Codable {
            self
            .session
            .request(
                type.url,
                method: type.httpMethod,
                parameters: params,
                encoding: type.encoding)
            .validate()
            .responseDecodable(of: T.self) {
                response in handler(response)
            }
        }
    
}
