//
//  Hero.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

enum Actor: String {
    
    case adagio = "*Adagio*"
    case alpha = "*Alpha*"
    case ardan = "*Ardan*"
    case baptiste = "*Baptiste*"
    case baron = "*Baron*"
    case blackfeather = "*Blackfeather*"
    case catherine = "*Catherine*"
    case celeste = "*Celeste*"
    
    case flicker = "*Flicker*"
    case fortress = "*Fortress*"
    case glaive = "*Glaive*"
    case grace = "*Grace*"
    case grumpjaw = "*Grumpjaw*"
    case gwen = "*Gwen*"
    case idris = "*Idris*"
    case joule = "*Joule*"
    
    
    case kestrel = "*Kestrel*"
    case koshka = "*Koshka*"
    case krul = "*Krul*"
    case lance = "*Lance*"
    case lyra = "*Lyra*"
    case ozo = "*Ozo*"
    case petal = "*Petal*"
    case phinn = "*Phinn*"
    
    case reim = "*Reim*"
    case ringo = "*Ringo*"
    case rona = "*Rona*"
    case samuel = "*Samuel*"
    case saw = "*SAW*"
    case skaarf = "*Skaarf*"
    case skye = "*Skye*"
    case taka = "*Taka*"
    
    case vox = "*Vox*"
  
    
    case leadMinion = "*LeadMinion*"
    case tankMinion = "*TankMinion*"
    case rangedMinion = "*RangedMinion*"
    
    case turret = "*Turret*"
    
    case blitzMiddleSentry = "*JungleMinion_Blitz_MiddleSentry*"
    
    case DefaultSmall = "*Neutral_JungleMinion_DefaultSmall*"
    case ElderTreeEnt = "*JungleMinion_ElderTreeEnt*"
    case DefaultBig = "*Neutral_JungleMinion_DefaultBig*"
    case TreeEnt = "*JungleMinion_TreeEnt*"
    
    case VainCrystal = "*VainCrystalHome*"
    
    case none = "None"
    
    init(string: String) {
        if let actor = Actor(rawValue: string) {
            self = actor
        } else {
            print("actor missing: \(string)")
            self = .none
        }
    }
    
    var imageUrl: String {
        switch self {
        case .adagio:
            return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/adagio.png"
        case .alpha: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/alpha.png"
        case .ardan: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/ardan.png"
        case .baptiste: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/baptiste.png"
        case .baron: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/baron.png"
        case .blackfeather: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/blackfeather.png"
        case .catherine: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/catherine.png"
        case .celeste: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/celeste.png"
            
        case .flicker: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/flicker.png"
        case .fortress: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/fortress.png"
        case .glaive: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/glaive.png"
        case .grace: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/grace.png"
        case .grumpjaw: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/grumpjaw.png"
        case .gwen: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/gwen.png"
        case .idris: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/idris.png"
        case .joule: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/joule.png"
            
        case .kestrel: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/kestrel.png"
        case .koshka: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/koshka.png"
        case .krul: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/krul.png"
        case .lance: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/lance.png"
        case .lyra: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/lyra.png"
        case .ozo: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/ozo.png"
        case .petal: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/petal.png"
        case .phinn: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/phinn.png"
            
        case .reim: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/reim.png"
        case .ringo: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/ringo.png"
        case .rona: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/rona.png"
        case .samuel: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/samuel.png"
        case .saw: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/saw.png"
        case .skaarf: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/skaarf.png"
        case .skye: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/skye.png"
        case .taka: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/taka.png"
            
        case .vox: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/vox.png"
            
        default: return "https://www.vaingloryfire.com/images/wikibase/icon/heroes/joule.png"
        }
    }
    
    var name: String {
        return rawValue.chopPrefix().chopSuffix()
    }
}
