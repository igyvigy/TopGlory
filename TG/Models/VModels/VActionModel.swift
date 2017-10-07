//
//  VAction.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

extension FActionModel {
    convenience init(json: JSON) {
        let action = Action.create(with: json) ?? .Unknown
        self.init(action: action)
    }
}

class ActionModel: VModel {
    var action: Action?
    
    init(json: JSON) {
        self.action = Action.create(with: json) ?? .Unknown
        super.init(json: JSON.null)
    }
    
    required convenience init(json: JSON, included: [VModel]?) {
        self.init(json: JSON.null, included: included)
        action = Action.create(with: json) ?? .Unknown
    }
}

extension Action {
    static func create(with json: JSON) -> Action? {
        guard let id = json["type"].string else { return nil }
        let time = json["time"].stringValue.dateFromISO8601 ?? .now
        switch id {
        case "HeroSwap":
            let jsonArray = json["payload"].arrayValue
            let swaps = jsonArray.map { Swap(json: $0) }
            return Action.HeroSwap(time: time, swaps: swaps)
        case "GoldFromGoldMine":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            return Action.GoldFromGoldMine(time: time, side: side, actor: actor, amount: amount)
        case "GoldFromTowerKill":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            return Action.GoldFromTowerKill(time: time, side: side, actor: actor, amount: amount)
        case "GoldFromKrakenKill":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            return Action.GoldFromKrakenKill(time: time, side: side, actor: actor, amount: amount)
        case "DealDamage":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let target = Actor(id: json["payload"]["Target"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let source = json["payload"]["Source"].stringValue
            let damage = json["payload"]["Damage"].intValue
            let delt = json["payload"]["Delt"].intValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            return Action.DealDamage(time: time, side: side, actor: actor, target: target, source: source, damage: damage, delt: delt, isHero: isHero, targetIsHero: targetIsHero)
        case "NPCkillNPC":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let killed = Actor(id: json["payload"]["Killed"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let gold = Int(json["payload"]["Gold"].stringValue) ?? 0
            let killedTeam = json["payload"]["KilledTeam"].stringValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            let position = Position(json: json["payload"]["Position"])
            return Action.NPCkillNPC(time: time, side: side, actor: actor, killed: killed, killedTeam: killedTeam, gold: gold, isHero: isHero, targetIsHero: targetIsHero, position: position)
        case "KillActor":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let killed = Actor(id: json["payload"]["Killed"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let gold = Int(json["payload"]["Gold"].stringValue) ?? 0
            let killedTeam = json["payload"]["KilledTeam"].stringValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            let position = Position(json: json["payload"]["Position"])
            return Action.KillActor(time: time, side: side, actor: actor, killed: killed, killedTeam: killedTeam, gold: gold, isHero: isHero, targetIsHero: targetIsHero, position: position)
        case "Executed":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let killed = Actor(id: json["payload"]["Killed"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let gold = Int(json["payload"]["Gold"].stringValue) ?? 0
            let killedTeam = json["payload"]["KilledTeam"].stringValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            let position = Position(json: json["payload"]["Position"])
            return Action.Executed(time: time, side: side, actor: actor, killed: killed, killedTeam: killedTeam, gold: gold, isHero: isHero, targetIsHero: targetIsHero, position: position)
        case "EarnXP":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let source = Actor(id: json["payload"]["Source"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            let sharedWith = json["payload"]["Shared With"].intValue
            return Action.EarnXP(time: time, side: side, actor: actor, source: source, amount: amount, sharedWith: sharedWith)
        case "LearnAbility":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let ability = Ability(string: json["payload"]["Ability"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let level = json["payload"]["Level"].intValue
            return Action.LearnAbility(time: time, side: side, actor: actor, ability: ability, level: level)
        case "UseAbility":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let targetActor = Actor(id: json["payload"]["TargetActor"].stringValue, type: .actor)
            let ability = Ability(string: json["payload"]["Ability"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let position = Position(json: json["payload"]["Position"])
            let targetPosition = Position(json: json["payload"]["TargetPosition"])
            return Action.UseAbility(time: time, side: side, actor: actor, ability: ability, position: position, targetActor: targetActor, targetPosition: targetPosition)
        case "UseItemAbility":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let targetActor = Actor(id: json["payload"]["TargetActor"].stringValue, type: .actor)
            let ability = Ability(string: json["payload"]["Ability"].stringValue)
            let side = Side(string: json["payload"]["Team"].string)
            let position = Position(json: json["payload"]["Position"])
            let targetPosition = Position(json: json["payload"]["TargetPosition"])
            return Action.UseItemAbility(time: time, side: side, actor: actor, ability: ability, position: position, targetActor: targetActor, targetPosition: targetPosition)
        case "BuyItem":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let item = Item(id: json["payload"]["Item"].stringValue, type: .item)
            let side = Side(string: json["payload"]["Team"].string)
            let price = json["payload"]["Cost"].intValue
            let remainingGold = json["payload"]["RemainingGold"].intValue
            let position = Position(json: json["payload"]["Position"])
            return Action.BuyItem(time: time, side: side, actor: actor, item: item, price: price, remainingGold: remainingGold, position: position)
        case "SellItem":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let item = Item(id: json["payload"]["Item"].stringValue, type: .item)
            let side = Side(string: json["payload"]["Team"].string)
            let price = json["payload"]["Cost"].intValue
            return Action.SellItem(time: time, side: side, actor: actor, item: item, price: price)
        case "LevelUp":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let level = json["payload"]["Level"].intValue
            let gold = json["payload"]["LifetimeGold"].intValue
            let side = Side(string: json["payload"]["Team"].string)
            return Action.LevelUp(time: time, side: side, actor: actor, level: level, gold: gold)
        case "PlayerFirstSpawn":
            let side = Side(string: json["payload"]["Team"].string)
            return Action.PlayerFirstSpawn(time: time, side: side)
        case "HeroBan":
            let actor = Actor(id: json["payload"]["Hero"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            return Action.HeroBan(time: time, actor: actor, side: side)
        case "HeroSelect":
            let actor = Actor(id: json["payload"]["Hero"].stringValue, type: .actor)
            let playerId = json["payload"]["Player"].stringValue
            let playerName = json["payload"]["Handle"].stringValue
            let side = Side(string: json["payload"]["Team"].string)
            return Action.HeroSelect(time: time, actor: actor, side: side, playerId: playerId, playerName: playerName)
        case "HeroSkinSelect":
            let actor = Actor(id: json["payload"]["Hero"].stringValue, type: .actor)
            let skin = Skin(id: json["payload"]["Skin"].stringValue, type: .skin)
            return Action.HeroSkinSelect(time: time, actor: actor, skin: skin)
        default:
            print("found unhandled action: \(id)")
            return nil
        }
    }
}
