//
//  Asset.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

typealias TelemetryCompletion = ([ActionModel]) -> Void
class Asset: Model {
    var url: String?
    var contentType: String?
    var createdAt: Date?
    var description: String?
    var filename: String?
    var name: String?
    
    init (model: Model) {
        super.init(id: model.id, type: model.type, attributes: model.attributes, relationships: model.relationships)
        decode()
    }
    
    required init(json: JSON, included: [Model]? = nil) {
        super.init(json: json, included: included)
    }
    
    private func decode() {
        guard let att = self.attributes as? JSON else { return }
        self.url = att["URL"].string
        self.contentType = att["contentType"].string
        self.createdAt = att["createdAt"].stringValue.dateFromISO8601WithoutTimeZone
        self.description = att["description"].string
        self.filename = att["filename"].string
        self.name = att["name"].string
    }
}

extension Asset {
    func loadTelemetry(withOwner owner: TGOwner? = nil,
                       loaderMessage: String? = nil,
                       control: Control? = nil,
                       onSuccess: @escaping TelemetryCompletion,
                       onError: Completion? = nil) {
        let router = Router.telemetry(urlString: url ?? "", contentType: contentType ?? "")
        Alamofire.request(try! router.asURLRequest())
            .responseJSON { response in
                debugPrint(response)
                if let object = response.result.value {
                    let jsonArray = JSON(object).arrayValue
                    onSuccess(jsonArray.map({ ActionModel(json: $0) }))
                }
        }
    }
    
}
