//
//  Model.swift
//  TG
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Link {
    case `selff`(link: String), next(link: String)
}

class Model {
    var id: String?
    var type: String?
    var attributes: Any?
    var relationships: Relationships?
    
    var rels: [Model] {
        var rels = [Model]()
        relationships?.categories?.forEach { rels.append(contentsOf: $0.data ?? [Model]()) }
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
    
    required init (json: JSON, included: [Model]? = nil) {
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
}

extension Model {
    func update(with model: Model) {
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
}

class Category {
    var name: String?
    var data: [Model]?
    var included: [Model]?
    var links: Links?
    
    init (name: String? = nil, json: JSON, included: [Model]? = nil) {
        
        self.name = name
        self.included = json["included"].arrayValue.map({ Model(json: $0, included: included) })
        if let arrayValue = json["data"].array {
            self.data = arrayValue.map({ Model(json: $0, included: included) })
        } else {
            self.data = [Model(json: json["data"], included: included)]
        }
        if let injectedIncluded = included {
            updateData(with: injectedIncluded)
        }
        if json["links"].dictionary != nil {
            self.links = Links(json: json["links"])
        }
    }
    
    func updateData(with included: [Model]) {
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
    
    init (json: JSON, included: [Model]? = nil) {
        var categories = [Category]()
        for (categoryName, dataJSON) in json.dictionaryValue {
            categories.append(Category(name: categoryName, json: dataJSON, included: included))
        }
        self.categories = categories
    }
    
    func update(with includes: [Model]) {
        categories?.forEach({ category in
            category.updateData(with: includes)
        })
    }
}
