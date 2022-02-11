//
//  EndpointType.swift
//  TV Shows
//
//  Created by Leo Goršić on 08.02.2022..
//

import Alamofire

///EndpointType is a protocol which defines all values that we need to form URL request.
protocol EndPointType {
    
    // MARK: - Vars & Lets
    
    /// Root or common URL
    var baseURL: String { get }
    /// Path to specific endpoint
    var path: String { get }
    /// Request method: GET, POST, PUT...
    var httpMethod: HTTPMethod { get }
    /// Complete URL for specific endpoint (base URL + path)
    var url: URL { get }
    /// Encoder   to be used to encode the request parameters value into the `URLRequest`
    var encoding: ParameterEncoding { get }
}
