//
//  Model.swift
//  TG
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

class Model {
    var id: String?
    var type: String?
    required init (dict: [String: Any?]) {
        self.id = dict["id"] as? String
        self.type = dict["type"] as? String
    }
    var encoded: [String : Any?] {
        return ["id": id ?? kEmptyStringValue, "type": type ?? kEmptyStringValue]
    }
}
