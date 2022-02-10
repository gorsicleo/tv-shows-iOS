//
//  EndpointType.swift
//  TV Shows
//
//  Created by Leo Goršić on 08.02.2022..
//

import Foundation
import Alamofire

///EndpointType is a protocol which defines all values that we need to form URL request.
protocol EndPointType {
    
    // MARK: - Vars & Lets
    
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var url: URL { get }
    var encoding: ParameterEncoding { get }
}
