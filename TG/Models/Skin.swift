//
//  Skin.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

var skinList = Set<String>() {
    didSet {
        print(skinList.sorted(by: { $0 < $1 }))
    }
}

class Skin: Model {

    required init(dict: [String: Any?]) {
        super.init(dict: dict)
        self.type = "Skin"
        self.id = dict["id"] as? String
        self.url = dict["url"] as? String
        self.name = dict["name"] as? String
    }

    required init(id: String, type: ModelType) {
        super.init(id: id, type: type)
    }
    
    override var encoded: [String : Any?] {
        let dict: [String: Any?] = [
            "id": id,
            "name": name,
            "url": url
        ]
        return dict
    }
}

enum SkinType: String, EnumCollection {
    case
    none = "none",
    Adagio_DefaultSkin = "Adagio_DefaultSkin",
    Adagio_Skin_Angel = "Adagio_Skin_Angel",
    Adagio_Skin_Goth_T1 = "Adagio_Skin_Goth_T1",
    Adagio_Skin_Goth_T2 = "Adagio_Skin_Goth_T2",
    Adagio_Skin_Goth_T3 = "Adagio_Skin_Goth_T3",
    Alpha_DefaultSkin = "Alpha_DefaultSkin",
    Alpha_Skin_Horror_T1 = "Alpha_Skin_Horror_T1",
    Alpha_Skin_Horror_T2 = "Alpha_Skin_Horror_T2",
    Alpha_Skin_Horror_T3 = "Alpha_Skin_Horror_T3",
    Ardan_DefaultSkin = "Ardan_DefaultSkin",
    Ardan_Skin_Fallen_T1 = "Ardan_Skin_Fallen_T1",
    Ardan_Skin_Fallen_T2 = "Ardan_Skin_Fallen_T2",
    Ardan_Skin_Fallen_T3 = "Ardan_Skin_Fallen_T3",
    Ardan_Skin_Glad = "Ardan_Skin_Glad",
    Baptiste_DefaultSkin = "Baptiste_DefaultSkin",
    Baron_DefaultSkin = "Baron_DefaultSkin",
    Baron_Skin_Terran_T1 = "Baron_Skin_Terran_T1",
    Blackfeather_DefaultSkin = "Blackfeather_DefaultSkin",
    Blackfeather_Skin_Dynasty_T1 = "Blackfeather_Skin_Dynasty_T1",
    Blackfeather_Skin_Dynasty_T2 = "Blackfeather_Skin_Dynasty_T2",
    Blackfeather_Skin_Dynasty_T3 = "Blackfeather_Skin_Dynasty_T3",
    Blackfeather_Skin_Vamp = "Blackfeather_Skin_Vamp",
    Catherine_DefaultSkin = "Catherine_DefaultSkin",
    Catherine_Skin_Glad = "Catherine_Skin_Glad",
    Catherine_Skin_Ice_RI = "Catherine_Skin_Ice_RI",
    Catherine_Skin_Vampire_T1 = "Catherine_Skin_Vampire_T1",
    Catherine_Skin_Vampire_T2 = "Catherine_Skin_Vampire_T2",
    Catherine_Skin_Vampire_T3 = "Catherine_Skin_Vampire_T3",
    Celeste_DefaultSkin = "Celeste_DefaultSkin",
    Celeste_Skin_Butterfly = "Celeste_Skin_Butterfly",
    Celeste_Skin_Hlwn_RI = "Celeste_Skin_Hlwn_RI",
    Celeste_Skin_Moon = "Celeste_Skin_Moon",
    Celeste_Skin_Queen_T1 = "Celeste_Skin_Queen_T1",
    Celeste_Skin_Queen_T2 = "Celeste_Skin_Queen_T2",
    Celeste_Skin_Queen_T3 = "Celeste_Skin_Queen_T3",
    Flicker_DefaultSkin = "Flicker_DefaultSkin",
    Flicker_Skin_Panda = "Flicker_Skin_Panda",
    Fortress_DefaultSkin = "Fortress_DefaultSkin",
    Fortress_Skin_Hell_T1 = "Fortress_Skin_Hell_T1",
    Fortress_Skin_Hell_T2 = "Fortress_Skin_Hell_T2",
    Fortress_Skin_Hell_T3 = "Fortress_Skin_Hell_T3",
    Fortress_Skin_Warg = "Fortress_Skin_Warg",
    Fortress_Skin_Xmas_RI = "Fortress_Skin_Xmas_RI",
    Glaive_DefaultSkin = "Glaive_DefaultSkin",
    Glaive_Skin_Prehistoric_T1 = "Glaive_Skin_Prehistoric_T1",
    Glaive_Skin_Prehistoric_T2 = "Glaive_Skin_Prehistoric_T2",
    Glaive_Skin_Prehistoric_T3 = "Glaive_Skin_Prehistoric_T3",
    Glaive_Skin_Sorrowblade = "Glaive_Skin_Sorrowblade",
    Grace_DefaultSkin = "Grace_DefaultSkin",
    Grumpjaw_DefaultSkin = "Grumpjaw_DefaultSkin",
    Grumpjaw_Skin_Bulldog = "Grumpjaw_Skin_Bulldog",
    Gwen_DefaultSkin = "Gwen_DefaultSkin",
    Gwen_Skin_Hitman = "Gwen_Skin_Hitman",
    Idris_DefaultSkin = "Idris_DefaultSkin",
    Idris_Skin_Wander = "Idris_Skin_Wander",
    Joule_DefaultSkin = "Joule_DefaultSkin",
    Joule_Skin_Killa_T1 = "Joule_Skin_Killa_T1",
    Joule_Skin_Killa_T2 = "Joule_Skin_Killa_T2",
    Joule_Skin_Killa_T3 = "Joule_Skin_Killa_T3",
    Joule_Skin_Snow = "Joule_Skin_Snow",
    Kestrel_DefaultSkin = "Kestrel_DefaultSkin",
    Kestrel_Skin_Drow = "Kestrel_Skin_Drow",
    Kestrel_Skin_Ice = "Kestrel_Skin_Ice",
    Kestrel_Skin_Summer = "Kestrel_Skin_Summer",
    Kestrel_Skin_Sylvan_T1 = "Kestrel_Skin_Sylvan_T1",
    Koshka_DefaultSkin = "Koshka_DefaultSkin",
    Koshka_Skin_CNY_RI = "Koshka_Skin_CNY_RI",
    Koshka_Skin_Rave_T1 = "Koshka_Skin_Rave_T1",
    Koshka_Skin_Rave_T2 = "Koshka_Skin_Rave_T2",
    Koshka_Skin_Rave_T3 = "Koshka_Skin_Rave_T3",
    Koshka_Skin_School = "Koshka_Skin_School",
    Krul_DefaultSkin = "Krul_DefaultSkin",
    Krul_Skin_Pirate = "Krul_Skin_Pirate",
    Krul_Skin_Rock_T1 = "Krul_Skin_Rock_T1",
    Krul_Skin_Rock_T2 = "Krul_Skin_Rock_T2",
    Krul_Skin_Rock_T3 = "Krul_Skin_Rock_T3",
    Krul_Skin_Summer = "Krul_Skin_Summer",
    Lance_DefaultSkin = "Lance_DefaultSkin",
    Lance_Skin_Deathknight = "Lance_Skin_Deathknight",
    Lance_Skin_Deathknight_T3 = "Lance_Skin_Deathknight_T3",
    Lance_Skin_Glad = "Lance_Skin_Glad",
    Lyra_DefaultSkin = "Lyra_DefaultSkin",
    Lyra_Skin_School = "Lyra_Skin_School",
    Lyra_Skin_Unicorn = "Lyra_Skin_Unicorn",
    Ozo_DefaultSkin = "Ozo_DefaultSkin",
    Ozo_Skin_Kungfu_T1 = "Ozo_Skin_Kungfu_T1",
    Petal_DefaultSkin = "Petal_DefaultSkin",
    Petal_Skin_Hlwn_RI = "Petal_Skin_Hlwn_RI",
    Petal_Skin_Bug_T1 = "Petal_Skin_Bug_T1",
    Petal_Skin_Bug_T2 = "Petal_Skin_Bug_T2",
    Petal_Skin_Bug_T3 = "Petal_Skin_Bug_T3",
    Phinn_DefaultSkin = "Phinn_DefaultSkin",
    Phinn_Skin_Captain = "Phinn_Skin_Captain",
    Phinn_Skin_Troll_T1 = "Phinn_Skin_Troll_T1",
    Phinn_Skin_Troll_T2 = "Phinn_Skin_Troll_T2",
    Phinn_Skin_Troll_T3 = "Phinn_Skin_Troll_T3",
    Reim_DefaultSkin = "Reim_DefaultSkin",
    Reim_Skin_IceMage = "Reim_Skin_IceMage",
    Reim_Skin_Thunder_T1 = "Reim_Skin_Thunder_T1",
    Reim_Skin_Thunder_T2 = "Reim_Skin_Thunder_T2",
    Reim_Skin_Thunder_T3 = "Reim_Skin_Thunder_T3",
    Reza_DefaultSkin = "Reza_DefaultSkin",
    Ringo_DefaultSkin = "Ringo_DefaultSkin",
    Ringo_Skin_Bakuto = "Ringo_Skin_Bakuto",
    Ringo_Skin_Shogun_T1 = "Ringo_Skin_Shogun_T1",
    Ringo_Skin_Shogun_T2 = "Ringo_Skin_Shogun_T2",
    Ringo_Skin_Shogun_T3 = "Ringo_Skin_Shogun_T3",
    Rona_DefaultSkin = "Rona_DefaultSkin",
    Rona_Skin_Bunny = "Rona_Skin_Bunny",
    Rona_Skin_Bunny_RI = "Rona_Skin_Bunny_RI",
    Rona_Skin_Fury_T1 = "Rona_Skin_Fury_T1",
    Rona_Skin_Fury_T2 = "Rona_Skin_Fury_T2",
    Rona_Skin_Fury_T3 = "Rona_Skin_Fury_T3",
    SAW_DefaultSkin = "SAW_DefaultSkin",
    SAW_Skin_Elite = "SAW_Skin_Elite",
    SAW_Skin_SAWborg_T1 = "SAW_Skin_SAWborg_T1",
    SAW_Skin_SAWborg_T2 = "SAW_Skin_SAWborg_T2",
    SAW_Skin_SAWborg_T3 = "SAW_Skin_SAWborg_T3",
    SAW_Skin_Summer = "SAW_Skin_Summer",
    Samuel_DefaultSkin = "Samuel_DefaultSkin",
    Samuel_Skin_Apprentice = "Samuel_Skin_Apprentice",
    Samuel_Skin_Cyber = "Samuel_Skin_Cyber",
    Skaarf_DefaultSkin = "Skaarf_DefaultSkin",
    Skaarf_Skin_CNY_A = "Skaarf_Skin_CNY_A",
    Skaarf_Skin_CNY_B = "Skaarf_Skin_CNY_B",
    Skaarf_Skin_CNY_C = "Skaarf_Skin_CNY_C",
    Skaarf_Skin_CNY_D = "Skaarf_Skin_CNY_D",
    Skaarf_Skin_CNY_E = "Skaarf_Skin_CNY_E",
    Skaarf_Skin_Infinity_T1 = "Skaarf_Skin_Infinity_T1",
    Skaarf_Skin_Infinity_T2 = "Skaarf_Skin_Infinity_T2",
    Skaarf_Skin_Infinity_T3 = "Skaarf_Skin_Infinity_T3",
    Skye_DefaultSkin = "Skye_DefaultSkin",
    Skye_Skin_Bike = "Skye_Skin_Bike",
    Skye_Skin_Eagle_T1 = "Skye_Skin_Eagle_T1",
    Skye_Skin_Eagle_T2 = "Skye_Skin_Eagle_T2",
    Skye_Skin_Eagle_T3 = "Skye_Skin_Eagle_T3",
    Taka_DefaultSkin = "Taka_DefaultSkin",
    Taka_Skin_Oni_RI = "Taka_Skin_Oni_RI",
    Taka_Skin_School = "Taka_Skin_School",
    Taka_Skin_Shin_T1 = "Taka_Skin_Shin_T1",
    Taka_Skin_Shin_T2 = "Taka_Skin_Shin_T2",
    Taka_Skin_Shin_T3 = "Taka_Skin_Shin_T3",
    Vox_DefaultSkin = "Vox_DefaultSkin",
    Vox_Skin_Pirate_T1 = "Vox_Skin_Pirate_T1",
    Vox_Skin_Pirate_T2 = "Vox_Skin_Pirate_T2",
    Vox_Skin_Pirate_T3 = "Vox_Skin_Pirate_T3",
    Vox_Skin_School = "Vox_Skin_School"
    
    
    init(string: String) {
        if let skin = SkinType(rawValue: string) {
            self = skin
        } else {
            
            print("skin missing: \(string)")
            if !skinList.contains(string) {
                skinList.insert(string)
            }
            self = .none
        }
    }
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

let allIds = [
    "Adagio_DefaultSkin",
    "Adagio_Skin_Angel",
    "Adagio_Skin_Goth_T1",
    "Adagio_Skin_Goth_T2",
    "Adagio_Skin_Goth_T3",
    "Alpha_DefaultSkin",
    "Alpha_Skin_Horror_T1",
    "Alpha_Skin_Horror_T2",
    "Alpha_Skin_Horror_T3",
    "Ardan_DefaultSkin",
    "Ardan_Skin_Fallen_T1",
    "Ardan_Skin_Fallen_T2",
    "Ardan_Skin_Fallen_T3",
    "Ardan_Skin_Glad",
    "Baptiste_DefaultSkin",
    "Baron_DefaultSkin",
    "Baron_Skin_Terran_T1",
    "Blackfeather_DefaultSkin",
    "Blackfeather_Skin_Dynasty_T1",
    "Blackfeather_Skin_Dynasty_T3",
    "Blackfeather_Skin_Vamp",
    "Catherine_DefaultSkin",
    "Catherine_Skin_Glad",
    "Catherine_Skin_Ice_RI",
    "Catherine_Skin_Vampire_T1",
    "Catherine_Skin_Vampire_T2",
    "Catherine_Skin_Vampire_T3",
    "Celeste_DefaultSkin",
    "Celeste_Skin_Butterfly",
    "Celeste_Skin_Hlwn_RI",
    "Celeste_Skin_Moon",
    "Celeste_Skin_Queen_T1",
    "Celeste_Skin_Queen_T2",
    "Celeste_Skin_Queen_T3",
    "Flicker_DefaultSkin",
    "Fortress_DefaultSkin",
    "Fortress_Skin_Hell_T1",
    "Fortress_Skin_Hell_T3",
    "Fortress_Skin_Warg",
    "Fortress_Skin_Xmas_RI",
    "Glaive_DefaultSkin",
    "Glaive_Skin_Prehistoric_T1",
    "Glaive_Skin_Prehistoric_T2",
    "Glaive_Skin_Prehistoric_T3",
    "Grace_DefaultSkin",
    "Grumpjaw_DefaultSkin",
    "Grumpjaw_Skin_Bulldog",
    "Gwen_DefaultSkin",
    "Gwen_Skin_Hitman",
    "Idris_DefaultSkin",
    "Idris_Skin_Wander",
    "Joule_DefaultSkin",
    "Joule_Skin_Killa_T1",
    "Joule_Skin_Killa_T2",
    "Joule_Skin_Killa_T3",
    "Joule_Skin_Snow",
    "Kestrel_DefaultSkin",
    "Kestrel_Skin_Drow",
    "Kestrel_Skin_Ice",
    "Kestrel_Skin_Summer",
    "Kestrel_Skin_Sylvan_T1",
    "Koshka_Skin_CNY_RI",
    "Koshka_Skin_Rave_T1",
    "Koshka_Skin_Rave_T2",
    "Koshka_Skin_Rave_T3",
    "Koshka_Skin_School",
    "Krul_DefaultSkin",
    "Krul_Skin_Pirate",
    "Krul_Skin_Rock_T1",
    "Krul_Skin_Rock_T3",
    "Krul_Skin_Summer",
    "Lance_DefaultSkin",
    "Lance_Skin_Deathknight",
    "Lance_Skin_Deathknight_T3",
    "Lance_Skin_Glad",
    "Lyra_DefaultSkin",
    "Lyra_Skin_School",
    "Lyra_Skin_Unicorn",
    "Ozo_DefaultSkin",
    "Ozo_Skin_Kungfu_T1",
    "Petal_DefaultSkin",
    "Petal_Skin_Bug_T1",
    "Petal_Skin_Bug_T2",
    "Petal_Skin_Bug_T3",
    "Phinn_DefaultSkin",
    "Phinn_Skin_Captain",
    "Phinn_Skin_Troll_T2",
    "Phinn_Skin_Troll_T3",
    "Reim_DefaultSkin",
    "Reim_Skin_IceMage",
    "Reim_Skin_Thunder_T1",
    "Reim_Skin_Thunder_T2",
    "Reza_DefaultSkin",
    "Ringo_DefaultSkin",
    "Ringo_Skin_Bakuto",
    "Ringo_Skin_Shogun_T1",
    "Ringo_Skin_Shogun_T2",
    "Ringo_Skin_Shogun_T3",
    "Rona_DefaultSkin",
    "Rona_Skin_Bunny",
    "Rona_Skin_Bunny_RI",
    "Rona_Skin_Fury_T1",
    "Rona_Skin_Fury_T2",
    "Rona_Skin_Fury_T3",
    "SAW_DefaultSkin",
    "SAW_Skin_Elite",
    "SAW_Skin_SAWborg_T1",
    "SAW_Skin_SAWborg_T2",
    "SAW_Skin_SAWborg_T3",
    "SAW_Skin_Summer",
    "Samuel_DefaultSkin",
    "Samuel_Skin_Apprentice",
    "Samuel_Skin_Cyber",
    "Skaarf_DefaultSkin",
    "Skaarf_Skin_CNY_C",
    "Skaarf_Skin_Infinity_T1",
    "Skaarf_Skin_Infinity_T2",
    "Skaarf_Skin_Infinity_T3",
    "Skye_DefaultSkin",
    "Skye_Skin_Bike",
    "Skye_Skin_Eagle_T1",
    "Skye_Skin_Eagle_T2",
    "Skye_Skin_Eagle_T3",
    "Taka_DefaultSkin",
    "Taka_Skin_Oni_RI",
    "Taka_Skin_School",
    "Taka_Skin_Shin_T1",
    "Taka_Skin_Shin_T2",
    "Taka_Skin_Shin_T3",
    "Vox_DefaultSkin",
    "Vox_Skin_Pirate_T1",
    "Vox_Skin_Pirate_T2",
    "Vox_Skin_Pirate_T3"
]
