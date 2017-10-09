//
//  Action.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

class Action: Model {
    
    var actionId: String?
    var time: Date?
    var payload: [String: Any]?
    
    required init(dict: [String: Any?]) {
        
        self.actionId = dict["actionId"] as? String
        self.time = (dict["timeStamp"] as? String ?? "").dateFromISO8601
        self.payload = dict["payload"] as? [String: Any]
        
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

enum ActionType: EnumCollection {
    var hashValue: Int {
        return id.hashValue
    }
    var id: String {
        switch self {
        case .HeroBan: return "HeroBan"
        case .HeroSelect: return "HeroSelect"
        case .HeroSkinSelect: return "HeroSkinSelect"
        case .PlayerFirstSpawn: return "PlayerFirstSpawn"
        case .LevelUp: return "LevelUp"
        case .BuyItem: return "BuyItem"
        case .SellItem: return "SellItem"
        case .LearnAbility: return "LearnAbility"
        case .UseAbility: return "UseAbility"
        case .UseItemAbility: return "UseItemAbility"
        case .EarnXP: return "EarnXP"
        case .KillActor: return "KillActor"
        case .DealDamage: return "DealDamage"
        case .Executed: return "Executed"
        case .GoldFromGoldMine: return "GoldFromGoldMine"
        case .GoldFromTowerKill: return "GoldFromTowerKill"
        case .GoldFromKrakenKill: return "GoldFromKrakenKill"
        case .NPCkillNPC: return "NPCkillNPC"
        case .HeroSwap: return "HeroSwap"
        case .Unknown: return "Unknown"
        }
    }
    
    case HeroBan(time: Date, actor: Actor, side: Side)
    case HeroSelect(time: Date, actor: Actor, side: Side, playerId: String, playerName: String)
    case HeroSkinSelect(time: Date, actor: Actor, skin: Skin)
    case PlayerFirstSpawn(time: Date, side: Side)
    case LevelUp(time: Date, side: Side, actor: Actor, level: Int, gold: Int)
    case BuyItem(time: Date, side: Side, actor: Actor, item: Item, price: Int, remainingGold: Int, position: Position)
    case SellItem(time: Date, side: Side, actor: Actor, item: Item, price: Int)
    case LearnAbility(time: Date, side: Side, actor: Actor, ability: Ability, level: Int)
    case UseAbility(time: Date, side: Side, actor: Actor, ability: Ability, position: Position, targetActor: Actor, targetPosition: Position)
    case UseItemAbility(time: Date, side: Side, actor: Actor, ability: Ability, position: Position, targetActor: Actor, targetPosition: Position)
    case EarnXP(time: Date, side: Side, actor: Actor, source: Actor, amount: Int, sharedWith: Int)
    case KillActor(time: Date, side: Side, actor: Actor, killed: Actor, killedTeam: String, gold: Int, isHero: Bool, targetIsHero: Bool, position: Position)
    case Executed(time: Date, side: Side, actor: Actor, killed: Actor, killedTeam: String, gold: Int, isHero: Bool, targetIsHero: Bool, position: Position)
    case DealDamage(time: Date, side: Side, actor: Actor, target: Actor, source: String, damage: Int, delt: Int, isHero: Bool, targetIsHero: Bool)
    case GoldFromGoldMine(time: Date, side: Side, actor: Actor, amount: Int)
    case GoldFromTowerKill(time: Date, side: Side, actor: Actor, amount: Int)
    case GoldFromKrakenKill(time: Date, side: Side, actor: Actor, amount: Int)
    case NPCkillNPC(time: Date, side: Side, actor: Actor, killed: Actor, killedTeam: String, gold: Int, isHero: Bool, targetIsHero: Bool, position: Position)
    case HeroSwap(time: Date, swaps: [Swap])
    case Unknown
}

func == (lhs: ActionType, rhs: ActionType) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
