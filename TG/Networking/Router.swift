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
    case telemetry(urlString: String, contentType: String)
    case nextMatches(nextPageURL: String)
    
    var method: HTTPMethod {
        switch self {
        case .matches: return .get
        case .match: return .get
        case .telemetry: return .get
        case .nextMatches: return .get
        }
    }
    
    var path: String {
        switch self {
        case .matches: return "/matches"
        case .match(let id, _): return "/matches/\(id)"
        case .telemetry: return ""
        case .nextMatches(let nextPageURL): return nextPageURL
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        let urlWithShard = url.appendingPathComponent("/" + AppConfig.currentShardId)
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
        case .telemetry(let urlString, let contentType):
            urlRequest = URLRequest(url: URL(string: urlString)!)
            urlRequest.httpMethod = method.rawValue
            urlRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        case .nextMatches:
            let url = try path.asURL()
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            let apiKey = AppConfig.apiKey
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")
            return request
        }
        return urlRequest
    }
}

