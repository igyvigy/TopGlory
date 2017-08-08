//
//  Action.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActionModel: Model {
    var action: Action?
    
    init(json: JSON) {
        self.action = Action.create(with: json) ?? .Unknown
        super.init(json: JSON.null)
    }
    
    required convenience init(json: JSON, included: [Model]?) {
        self.init(json: JSON.null, included: included)
        action = Action.create(with: json) ?? .Unknown
    }
}

enum Action: EnumCollection {
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
    case Unknown
}

extension Action {
    static func create(with json: JSON) -> Action? {
        guard let id = json["type"].string else { return nil }
        let time = json["time"].stringValue.dateFromISO8601 ?? .now
        switch id {
            
        case "GoldFromGoldMine":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            return Action.GoldFromGoldMine(time: time, side: side, actor: actor, amount: amount)
        case "DealDamage":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let target = Actor(string: json["payload"]["Target"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let source = json["payload"]["Source"].stringValue
            let damage = json["payload"]["Damage"].intValue
            let delt = json["payload"]["Delt"].intValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            return Action.DealDamage(time: time, side: side, actor: actor, target: target, source: source, damage: damage, delt: delt, isHero: isHero, targetIsHero: targetIsHero)
        case "KillActor":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let killed = Actor(string: json["payload"]["Killed"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let gold = Int(json["payload"]["Gold"].stringValue) ?? 0
            let killedTeam = json["payload"]["KilledTeam"].stringValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            let position = Position(json: json["payload"]["Position"])
            return Action.KillActor(time: time, side: side, actor: actor, killed: killed, killedTeam: killedTeam, gold: gold, isHero: isHero, targetIsHero: targetIsHero, position: position)
        case "Executed":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let killed = Actor(string: json["payload"]["Killed"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let gold = Int(json["payload"]["Gold"].stringValue) ?? 0
            let killedTeam = json["payload"]["KilledTeam"].stringValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            let position = Position(json: json["payload"]["Position"])
            return Action.Executed(time: time, side: side, actor: actor, killed: killed, killedTeam: killedTeam, gold: gold, isHero: isHero, targetIsHero: targetIsHero, position: position)
        case "EarnXP":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let source = Actor(string: json["payload"]["Source"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            let sharedWith = json["payload"]["Shared With"].intValue
            return Action.EarnXP(time: time, side: side, actor: actor, source: source, amount: amount, sharedWith: sharedWith)
        case "LearnAbility":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let ability = Ability(string: json["payload"]["Ability"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let level = json["payload"]["Level"].intValue
            return Action.LearnAbility(time: time, side: side, actor: actor, ability: ability, level: level)
        case "UseAbility":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let targetActor = Actor(string: json["payload"]["TargetActor"].stringValue)
            let ability = Ability(string: json["payload"]["Ability"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let position = Position(json: json["payload"]["Position"])
            let targetPosition = Position(json: json["payload"]["TargetPosition"])
            return Action.UseAbility(time: time, side: side, actor: actor, ability: ability, position: position, targetActor: targetActor, targetPosition: targetPosition)
        case "UseItemAbility":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let targetActor = Actor(string: json["payload"]["TargetActor"].stringValue)
            let ability = Ability(string: json["payload"]["Ability"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let position = Position(json: json["payload"]["Position"])
            let targetPosition = Position(json: json["payload"]["TargetPosition"])
            return Action.UseItemAbility(time: time, side: side, actor: actor, ability: ability, position: position, targetActor: targetActor, targetPosition: targetPosition)
        case "BuyItem":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let item = Item(string: json["payload"]["Item"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let price = json["payload"]["Cost"].intValue
            let remainingGold = json["payload"]["RemainingGold"].intValue
            let position = Position(json: json["payload"]["Position"])
            return Action.BuyItem(time: time, side: side, actor: actor, item: item, price: price, remainingGold: remainingGold, position: position)
        case "SellItem":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let item = Item(string: json["payload"]["Item"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let price = json["payload"]["Cost"].intValue
            return Action.SellItem(time: time, side: side, actor: actor, item: item, price: price)
        case "LevelUp":
            let actor = Actor(string: json["payload"]["Actor"].stringValue)
            let level = json["payload"]["Level"].intValue
            let gold = json["payload"]["LifetimeGold"].intValue
            let side = Side(string: json["payload"]["Team"].string)
            return Action.LevelUp(time: time, side: side, actor: actor, level: level, gold: gold)
        case "PlayerFirstSpawn":
            let side = Side(string: json["payload"]["Team"].string)
            return Action.PlayerFirstSpawn(time: time, side: side)
        case "HeroBan":
            let actor = Actor(string: json["payload"]["Hero"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            return Action.HeroBan(time: time, actor: actor, side: side)
        case "HeroSelect":
            let actor = Actor(string: json["payload"]["Hero"].stringValue)
            let playerId = json["payload"]["Player"].stringValue
            let playerName = json["payload"]["Handle"].stringValue
            let side = Side(string: json["payload"]["Team"].string)
            return Action.HeroSelect(time: time, actor: actor, side: side, playerId: playerId, playerName: playerName)
        case "HeroSkinSelect":
            let actor = Actor(string: json["payload"]["Hero"].stringValue)
            let skin = Skin(string: json["payload"]["Skin"].stringValue)
            return Action.HeroSkinSelect(time: time, actor: actor, skin: skin)
        default:
            print("found unhandled action: \(id)")
            return nil
        }
    }
    
}

func == (lhs: Action, rhs: Action) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
