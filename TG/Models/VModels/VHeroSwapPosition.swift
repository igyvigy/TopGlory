//
//  VHeroSwapPosition.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Swap {
    init (json: JSON) {
        hero = Actor(id: json["Hero"].stringValue, type: .actor)
        playerId = json["Player"].string
        side = Side(string: json["Team"].string)
    }
}

extension Position {
    init (json: JSON) {
        self.x = json.arrayValue[0].doubleValue
        self.y = json.arrayValue[1].doubleValue
        self.z = json.arrayValue[2].doubleValue
    }
}
