//
//  Swap.swift
//  TG
//
//  Created by Andrii Narinian on 8/13/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

struct Swap {
    var hero: Actor?
    var playerId: String?
    var side: Side?
    
    var encoded: [String : Any?] {
        return [
            "hero": hero?.encoded,
            "playerId": playerId,
            "side": side?.identifier
        ]
    }
}
