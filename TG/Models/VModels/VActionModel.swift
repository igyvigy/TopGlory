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
        let action = ActionType.create(with: json) ?? .Unknown
        self.init(action: action)
    }
}

class ActionModel: VModel {

    var name: String?
    var url: String?
    
    var actionId: String?
    var timeStamp: String?
    var payload: [String: Any]?
    
    var playerName: String?
    var playerId: String?
    var gold: Int?
    var lifetimeGold: Int?
    var remainingGold: Int?
    var level: Int?
    var price: Int?
    var damage: Int?
    var expAmount: Int?
    var deltDamage: Int?
    var isHero: Int?
    var targetIsHero: Int?
    var sharedWithCount: Int?
    
    var position: [Double]?
    var targetPosition: [Double]?
    var swaps: [Swap]?
    var actorIdentifier: String?
    var actor: Actor? {
        guard let id = actorIdentifier else { return nil }
        return Actor(id: id, type: .actor)
    }
    var targetActorIdentifier: String?
    var targetActor: Actor? {
        guard let id = targetActorIdentifier else { return nil }
        return Actor(id: id, type: .actor)
    }
    var skinIdentifier: String?
    var skin: Skin? {
        guard let id = skinIdentifier else { return nil }
        return Skin(id: id, type: .skin)
    }
    var sideString: String?
    var side: Side? {
        return Side(string: sideString)
    }
    var targetSideString: String?
    var targetSide: Side? {
        return Side(string: targetSideString)
    }
    var abilityString: String?
    var ability: Ability? {
        guard let id = abilityString else { return nil }
        return Ability(id: id, type: .ability)
    }

    required init(json: JSON, included: [VModel]? = nil) {
        super.init(json: json, included: included)
        decode(json)
    }
    
    override var encoded: [String : Any?] {
        let dict: [String: Any?] = [
            "type": type,
            "id": id,
            "url": url,
            "name": name,
            
            "actionId": actionId,
            "timeStamp": timeStamp,
            "payload": payload,
            
            
            "playerName": playerName,
            "playerId": playerId,
            "gold": gold,
            "lifetimeGold": lifetimeGold,
            "remainingGold": remainingGold,
            "level": level,
            "price": price,
            "damage": damage,
            "expAmount": expAmount,
            "deltDamage": deltDamage,
            "isHero": isHero,
            "targetIsHero": targetIsHero,
            "sharedWithCount": sharedWithCount,
            "swaps": swaps?.map { $0.encoded },
            "position": position,
            "targetPosition": targetPosition,
            
            "actor": actor?.encoded,
            "targetActor": targetActor?.encoded,
            "skin": skin?.encoded,
            "side": side?.identifier,
            "targetSide": targetSide?.identifier,
            "ability": ability?.encoded
            ]
        return dict
    }
    
    private func decode(_ json: JSON) {
        id = json["id"].string
        type = "Action"
        
        name = json["name"].string
        url = json["url"].string
        
        actionId = json["type"].string
        timeStamp = json["time"].string
        payload = json["payload"].dictionaryObject
        
        playerId = json["payload"]["Player"].string
        swaps = json["payload"].arrayValue.map { Swap(json: $0) }
        gold = json["payload"]["Gold"].int
        lifetimeGold = json["payload"]["url"].int
        remainingGold = json["payload"]["url"].int
        level = json["payload"]["url"].int
        price = json["payload"]["url"].int
        damage = json["payload"]["url"].int
        expAmount = json["payload"]["url"].int
        deltDamage = json["payload"]["url"].int
        isHero = json["payload"]["url"].int
        targetIsHero = json["payload"]["url"].int
        sharedWithCount = json["payload"]["url"].int
        position = json["payload"]["url"].arrayObject as? [Double]
        targetPosition = json["payload"]["url"].arrayObject as? [Double]
        actorIdentifier = json["payload"]["url"].string
        targetActorIdentifier = json["payload"]["Hero"].string
        skinIdentifier = json["payload"]["url"].string
        sideString = json["payload"]["url"].string
        targetSideString = json["payload"]["url"].string
        abilityString = json["payload"]["url"].string
    }
}

extension ActionType {
    static func create(with json: JSON) -> ActionType? {
        guard let id = json["type"].string else { return nil }
        let time = json["time"].stringValue.dateFromISO8601 ?? .now
        switch id {
        case "HeroSwap":
            let jsonArray = json["payload"].arrayValue
            let swaps = jsonArray.map { Swap(json: $0) }
            return ActionType.HeroSwap(time: time, swaps: swaps)
        case "GoldFromGoldMine":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            return ActionType.GoldFromGoldMine(time: time, side: side, actor: actor, amount: amount)
        case "GoldFromTowerKill":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            return ActionType.GoldFromTowerKill(time: time, side: side, actor: actor, amount: amount)
        case "GoldFromKrakenKill":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            return ActionType.GoldFromKrakenKill(time: time, side: side, actor: actor, amount: amount)
        case "DealDamage":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let target = Actor(id: json["payload"]["Target"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let source = json["payload"]["Source"].stringValue
            let damage = json["payload"]["Damage"].intValue
            let delt = json["payload"]["Delt"].intValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            return ActionType.DealDamage(time: time, side: side, actor: actor, target: target, source: source, damage: damage, delt: delt, isHero: isHero, targetIsHero: targetIsHero)
        case "NPCkillNPC":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let killed = Actor(id: json["payload"]["Killed"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let gold = Int(json["payload"]["Gold"].stringValue) ?? 0
            let killedTeam = json["payload"]["KilledTeam"].stringValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            let position = Position(json: json["payload"]["Position"])
            return ActionType.NPCkillNPC(time: time, side: side, actor: actor, killed: killed, killedTeam: killedTeam, gold: gold, isHero: isHero, targetIsHero: targetIsHero, position: position)
        case "KillActor":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let killed = Actor(id: json["payload"]["Killed"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let gold = Int(json["payload"]["Gold"].stringValue) ?? 0
            let killedTeam = json["payload"]["KilledTeam"].stringValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            let position = Position(json: json["payload"]["Position"])
            return ActionType.KillActor(time: time, side: side, actor: actor, killed: killed, killedTeam: killedTeam, gold: gold, isHero: isHero, targetIsHero: targetIsHero, position: position)
        case "Executed":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let killed = Actor(id: json["payload"]["Killed"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let gold = Int(json["payload"]["Gold"].stringValue) ?? 0
            let killedTeam = json["payload"]["KilledTeam"].stringValue
            let isHero = json["payload"]["IsHero"].intValue == 1
            let targetIsHero = json["payload"]["TargetIsHero"].intValue == 1
            let position = Position(json: json["payload"]["Position"])
            return ActionType.Executed(time: time, side: side, actor: actor, killed: killed, killedTeam: killedTeam, gold: gold, isHero: isHero, targetIsHero: targetIsHero, position: position)
        case "EarnXP":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let source = Actor(id: json["payload"]["Source"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            let amount = json["payload"]["Amount"].intValue
            let sharedWith = json["payload"]["Shared With"].intValue
            return ActionType.EarnXP(time: time, side: side, actor: actor, source: source, amount: amount, sharedWith: sharedWith)
        case "LearnAbility":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let ability = Ability(id: json["payload"]["Ability"].stringValue, type: .ability)
            let side = Side(string: json["payload"]["Team"].string)
            let level = json["payload"]["Level"].intValue
            return ActionType.LearnAbility(time: time, side: side, actor: actor, ability: ability, level: level)
        case "UseAbility":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let targetActor = Actor(id: json["payload"]["TargetActor"].stringValue, type: .actor)
            let ability = Ability(id: json["payload"]["Ability"].stringValue, type: .ability)
            let side = Side(string: json["payload"]["Team"].string)
            let position = Position(json: json["payload"]["Position"])
            let targetPosition = Position(json: json["payload"]["TargetPosition"])
            return ActionType.UseAbility(time: time, side: side, actor: actor, ability: ability, position: position, targetActor: targetActor, targetPosition: targetPosition)
        case "UseItemAbility":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let targetActor = Actor(id: json["payload"]["TargetActor"].stringValue, type: .actor)
            let ability = Ability(id: json["payload"]["Ability"].stringValue, type: .ability)
            let side = Side(string: json["payload"]["Team"].string)
            let position = Position(json: json["payload"]["Position"])
            let targetPosition = Position(json: json["payload"]["TargetPosition"])
            return ActionType.UseItemAbility(time: time, side: side, actor: actor, ability: ability, position: position, targetActor: targetActor, targetPosition: targetPosition)
        case "BuyItem":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let item = Item(id: json["payload"]["Item"].stringValue, type: .item)
            let side = Side(string: json["payload"]["Team"].string)
            let price = json["payload"]["Cost"].intValue
            let remainingGold = json["payload"]["RemainingGold"].intValue
            let position = Position(json: json["payload"]["Position"])
            return ActionType.BuyItem(time: time, side: side, actor: actor, item: item, price: price, remainingGold: remainingGold, position: position)
        case "SellItem":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let item = Item(id: json["payload"]["Item"].stringValue, type: .item)
            let side = Side(string: json["payload"]["Team"].string)
            let price = json["payload"]["Cost"].intValue
            return ActionType.SellItem(time: time, side: side, actor: actor, item: item, price: price)
        case "LevelUp":
            let actor = Actor(id: json["payload"]["Actor"].stringValue, type: .actor)
            let level = json["payload"]["Level"].intValue
            let gold = json["payload"]["LifetimeGold"].intValue
            let side = Side(string: json["payload"]["Team"].string)
            return ActionType.LevelUp(time: time, side: side, actor: actor, level: level, gold: gold)
        case "PlayerFirstSpawn":
            let side = Side(string: json["payload"]["Team"].string)
            return ActionType.PlayerFirstSpawn(time: time, side: side)
        case "HeroBan":
            let actor = Actor(id: json["payload"]["Hero"].stringValue, type: .actor)
            let side = Side(string: json["payload"]["Team"].string)
            return ActionType.HeroBan(time: time, actor: actor, side: side)
        case "HeroSelect":
            let actor = Actor(id: json["payload"]["Hero"].stringValue, type: .actor)
            let playerId = json["payload"]["Player"].stringValue
            let playerName = json["payload"]["Handle"].stringValue
            let side = Side(string: json["payload"]["Team"].string)
            return ActionType.HeroSelect(time: time, actor: actor, side: side, playerId: playerId, playerName: playerName)
        case "HeroSkinSelect":
            let actor = Actor(id: json["payload"]["Hero"].stringValue, type: .actor)
            let skin = Skin(id: json["payload"]["Skin"].stringValue, type: .skin)
            return ActionType.HeroSkinSelect(time: time, actor: actor, skin: skin)
        default:
            print("found unhandled action: \(id)")
            return nil
        }
    }
}
