//
//  Skin.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

enum Skin: String {
    case
    none,
    Vox_Skin_School,
    Koshka_DefaultSkin
    
    init(string: String) {
        if let skin = Skin(rawValue: string) {
            self = skin
        } else {
            print("skin missing: \(string)")
            self = .none
        }
    }
}
