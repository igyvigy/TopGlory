//
//  Position.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Position {
    var x: Double
    var y: Double
    var z: Double
    
    init (json: JSON) {
        self.x = json.arrayValue[0].doubleValue
        self.y = json.arrayValue[1].doubleValue
        self.z = json.arrayValue[2].doubleValue
    }
}
