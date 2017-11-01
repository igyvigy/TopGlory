//
//  VModel.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Link {
    case `selff`(link: String), next(link: String)
}

extension FirebaseHelper {
    static func save(model: Model) {
        guard let currentUserName = AppConfig.currentUserName else { return }
        let values = model.encoded
        existsForCurrentUser(model: model) { exists in
            if !exists {
                updateValues(
                    on: historyReference
                        .child(currentUserName)
                        .child(model.type ?? "no_type")
                        .child(model.id ?? "no_id"),
                    values: values
                )
            }
        }
    }
    
    static func existsForCurrentUser(model: Model, completion: @escaping ( Bool ) -> Void) {
        guard let currentUserName = AppConfig.currentUserName else {
            completion(false)
            
            return }
        historyReference
            .child(currentUserName)
            .child(model.type ?? "no_type")
            .child(model.id ?? "no_id")
            .observeSingleEvent(of: .value, with: { snap in
                completion(snap.exists())
            }, withCancel: { _ in
                completion(false)
            })
    }
}

class VModel {
    var id: String?
    var type: String?
    var attributes: Any?
    var relationships: Relationships?
    
    var rels: [VModel] {
        var rels = [VModel]()
        relationships?.categories?.forEach { rels.append(contentsOf: $0.data ?? [VModel]()) }
        return rels
    }
    
    init (id: String?,
          type: String?,
          attributes: Any?,
          relationships: Relationships?) {
        self.id = id
        self.type = type
        self.attributes = attributes
        self.relationships = relationships
    }
    
    required init (json: JSON, included: [VModel]? = nil) {
        var jsonModel = [String: JSON]()
        if let data = json["data"].dictionary {
            jsonModel = data
        } else {
            jsonModel = json.dictionaryValue
        }
        self.id = jsonModel["id"]?.string
        self.type = jsonModel["type"]?.string
        self.attributes = jsonModel["attributes"]
        self.relationships = Relationships(json: jsonModel["relationships"] ?? JSON.null, included: included)
    }
    
    var encoded: [String: Any?] {
        return [:]
    }
    
}

extension VModel {
    func update(with model: VModel) {
        self.id = model.id
        self.type = model.type
        self.attributes = model.attributes
        self.relationships = model.relationships
    }
    
    func parseAttributes() -> [String: Any]? {
        guard let json = attributes as? JSON else { return nil }
        var output = [String: Any]()
        for (key, value) in json.dictionaryValue {
            if value.dictionary != nil {
                output = parseLayer(json: value, transferData: output)
            } else {
                output[key] = value.object
            }
        }
        return output
    }
    
    private func parseLayer(json: JSON, transferData: [String: Any]) -> [String: Any] {
        var output = transferData
        for (key, value) in json.dictionaryValue {
            if value.dictionary != nil {
                output = parseLayer(json: value, transferData: output)
            } else {
                output[key] = value.object
            }
        }
        return output
    }
    
    //    static func mapDict(_ dict: [String: Any?], _ sequence: @escaping (String, Any?) -> (String, Any?)) -> [String: Any] {
    //        var newDict = [String: Any]()
    //        dict.keys.forEach { key in
    //            let value: Any? = dict[key] as Any
    //            let map = sequence(key, value)
    //            newDict[map.0] = map.1
    //        }
    //        return newDict
    //    }
}

class Category {
    var name: String?
    var data: [VModel]?
    var included: [VModel]?
    var links: Links?
    
    init (name: String? = nil, json: JSON, included: [VModel]? = nil) {
        
        self.name = name
        self.included = json["included"].arrayValue.map({ VModel(json: $0, included: included) })
        if let arrayValue = json["data"].array {
            self.data = arrayValue.map({ VModel(json: $0, included: included) })
        } else {
            self.data = [VModel(json: json["data"], included: included)]
        }
        if let injectedIncluded = included {
            updateData(with: injectedIncluded)
        }
        if json["links"].dictionary != nil {
            self.links = Links(json: json["links"])
        }
        
    }
    
    func updateData(with included: [VModel]) {
        data?.forEach { storedModel in
            if let includedModel = included.filter({ ($0.id == storedModel.id) && ($0.type == storedModel.type) }).first {
                storedModel.update(with: includedModel)
            }
            if storedModel.relationships?.categories?.count ?? 0 > 0 {
                storedModel.relationships?.update(with: included)
            }
        }
    }
}

class Links {
    var next: String?
    var selff: String?
    
    init (json: JSON) {
        next = json["next"].string
        selff = json["self"].string
    }
}

class Relationships {
    var categories: [Category]?
    
    init (json: JSON, included: [VModel]? = nil) {
        var categories = [Category]()
        for (categoryName, dataJSON) in json.dictionaryValue {
            categories.append(Category(name: categoryName, json: dataJSON, included: included))
        }
        self.categories = categories
    }
    
    func update(with includes: [VModel]) {
        categories?.forEach({ category in
            category.updateData(with: includes)
        })
    }
}
