//
//  HeroSwap.swift
//  TG
//
//  Created by Andrii Narinian on 8/13/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Swap {
    var hero: Actor?
    var playerId: String?
    var side: Side?
    
    init (json: JSON) {
        hero = Actor(string: json["Hero"].stringValue)
        playerId = json["Player"].string
        side = Side(string: json["Team"].string)
    }
}
