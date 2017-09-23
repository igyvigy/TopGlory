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
typealias TelemetryFCompletion = ([FActionModel]) -> Void

class FAsset: FModel {
    var url: String?
    var contentType: String?
    var createdAt: Date?
    var description: String?
    var filename: String?
    var name: String?
    
    required init(dict: [String: Any]) {
        self.url = dict["url"] as? String
        self.contentType = dict["contentType"] as? String
        self.createdAt = TGDateFormats.iso8601WithoutTimeZone.date(from: dict["createdAt"] as? String ?? "")
        self.description = dict["description"] as? String
        self.filename = dict["filename"] as? String
        self.name = dict["name"] as? String
        super.init(dict: dict)
        self.id = dict["id"] as? String
        self.type = dict["type"] as? String
    }
    
    override var encoded: [String : Any] {
        let dict: [String: Any] = [
            "id": id,
            "type": type,
            "url": url,
            "contentType": contentType,
            "createdAt": TGDateFormats.iso8601WithoutTimeZone.string(from: createdAt ?? Date()),
            "description": description,
            "filename": filename,
            "name": name
        ]
        return dict
    }
}

extension FAsset {
    func loadTelemetry(withOwner owner: TGOwner? = nil,
                       loaderMessage: String? = nil,
                       control: Control? = nil,
                       onSuccess: @escaping TelemetryFCompletion,
                       onError: Completion? = nil) {
        let router = Router.telemetry(urlString: url ?? "", contentType: contentType ?? "")
        Alamofire.request(try! router.asURLRequest())
            .responseJSON { response in
                debugPrint(response)
                if let object = response.result.value {
                    let jsonArray = JSON(object).arrayValue
                    onSuccess(jsonArray.map({ FActionModel(json: $0) }))
                }
        }
    }
    
}

class Asset: VModel {
    var url: String?
    var contentType: String?
    var createdAt: Date?
    var description: String?
    var filename: String?
    var name: String?
    
    init (model: VModel) {
        super.init(id: model.id, type: model.type, attributes: model.attributes, relationships: model.relationships)
        decode()
    }
    
    required init(json: JSON, included: [VModel]? = nil) {
        super.init(json: json, included: included)
    }
    
    override var encoded: [String : Any] {
        let dict: [String: Any] = [
            "id": id,
            "type": type,
            "url": url,
            "contentType": contentType,
            "createdAt": TGDateFormats.iso8601WithoutTimeZone.string(from: createdAt ?? Date()),
            "description": description,
            "filename": filename,
            "name": name
        ]
        return dict
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
