//
//  Router.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import Alamofire

enum Router: RouterCompatible {
    static let baseURLString = AppConfig.API_URL
    
    case matches(parameters: Parameters)
    case match(id: String, parameters: Parameters)
    
    var method: HTTPMethod {
        switch self {
        case .matches: return .get
        case .match: return .get
        }
    }
    
    var path: String {
        switch self {
        case .matches: return "/matches"
        case .match(let id, _): return "/matches/\(id)"
        }
    }
        
    var shard: String {
        return "/eu"
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        let urlWithShard = url.appendingPathComponent(shard)
        var urlRequest = URLRequest(url: urlWithShard.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        let apiKey = AppConfig.apiKey
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(apiKey, forHTTPHeaderField: "Authorization")

        switch self {
        case .matches(let parameters),
             .match(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
//        default:
//            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }
}

