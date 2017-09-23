//
//  VHeroSwapPosition.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

extension HeroSwap {
    init (json: JSON) {
        hero = Actor(string: json["Hero"].stringValue)
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
