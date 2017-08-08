//
//  Ability.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

enum Ability: String {
    case
    koshka_b = "HERO_ABILITY_KOSHKA_TWIRL_NAME",
    phinn_a = "HERO_ABILITY_PHINN_A_NAME",
    vox_b = "HERO_ABILITY_VOX_B_NAME",
    none = "None"
    
    init(string: String) {
        if let ability = Ability(rawValue: string) {
            self = ability
        } else {
            print("ability missing: \(string)")
            self = .none
        }
    }
}
