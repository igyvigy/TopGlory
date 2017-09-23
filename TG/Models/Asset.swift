//
//  Asset.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

typealias TelemetryFCompletion = ([FActionModel]) -> Void

class FActionModel: Model {
    var action: Action?
    
    required init(dict: [String : Any?]) {
        super.init(dict: dict)
    }
}

class Asset: Model {
    var url: String?
    var contentType: String?
    var createdAt: Date?
    var description: String?
    var filename: String?
    var name: String?
    
    required init(dict: [String: Any?]) {
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
    
    override var encoded: [String : Any?] {
        let dict: [String: Any?] = [
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


