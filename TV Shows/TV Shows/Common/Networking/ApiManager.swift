//
//  ApiManager.swift
//  TV Shows
//
//  Created by Leo Goršić on 09.02.2022..
//

import Alamofire

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
