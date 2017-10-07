//
//  Participant.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

enum ItemStatsModelType: String {
    case itemSells, itemGrants, itemUses, header
}

class ItemStatsModel: Model {

    var itemCount: Int
    var itemStatsModelType: ItemStatsModelType
    var itemStatsId: String?
    
    init (itemStatsId: String?, itemCount: Int, modelType: ItemStatsModelType) {
        
        self.itemCount = itemCount
        self.itemStatsModelType = modelType
        self.itemStatsId = itemStatsId
        super.init(dict: [:])
    }
    
    required init(dict: [String : Any?]) {
        
        self.itemCount = dict["count"] as? Int ?? 0
        self.itemStatsModelType = ItemStatsModelType(rawValue: dict["modelType"] as? String ?? "") ?? .itemGrants
        super.init(dict: dict)
        self.name = dict["name"] as? String
        self.id = dict["id"] as? String
    }
    
    required init(id: String, type: ModelType) {
        self.itemCount = 0
        self.itemStatsModelType = .itemGrants
        super.init(id: id, type: type)
    }
    
}

class ItemStats {
    var stats: [String: Int]
    init(stats: [String: Int]) {
        self.stats = stats
    }
}
class ItemGrants: ItemStats {}
class ItemSells: ItemStats {}
class ItemUses: ItemStats {}

class Participant: Model {
    var actor: Actor?
    var shardId: String?
    var assists: Int?
    var crystalMineCaptures: Int?
    var deaths: Int?
    var farm: Double?
    var firstAfkTime: Int?
    var gold: Double?
    var goldMineCaptures: Int?
    var itemGrants: ItemGrants?
    var itemSells: ItemSells?
    var itemUses: ItemUses?
    var items: [String]?
    var jungleKills: Int?
    var karmaLevel: Int?
    var kills: Int?
    var krakenCaptures: Int?
    var level: Int?
    var minionKills: Int?
    var nonJungleMinionKills: Int?
    var skillTier: Int?
    var skin: Skin?
    var turretCaptures: Int?
    var wentAfk: Bool?
    var winner: Bool?
    var player: Player?
    var playerName: String?
    var playerWinsString: String?
    var itemObjects: [Item]?
    var isUser: Bool?
    
    required init(dict: [String: Any?]) {
        self.actor = Actor(id: dict["actor"] as? String ?? "", type: .actor)
        self.shardId = dict["shardId"] as? String
        self.assists = dict["assists"] as? Int
        self.crystalMineCaptures = dict["crystalMineCaptures"] as? Int
        self.deaths = dict["deaths"] as? Int
        self.farm = dict["farm"] as? Double
        self.firstAfkTime = dict["firstAfkTime"] as? Int
        self.gold = dict["gold"] as? Double
        self.goldMineCaptures = dict["goldMineCaptures"] as? Int
        self.itemGrants = ItemGrants(stats: dict["itemGrants"] as? [String: Int] ?? [String: Int]())
        self.itemSells = ItemSells(stats: dict["itemSells"] as? [String: Int] ?? [String: Int]())
        self.itemUses = ItemUses(stats: dict["itemUses"] as? [String: Int] ?? [String: Int]())
        self.items = dict["items"] as? [String]
        self.jungleKills = dict["jungleKills"] as? Int
        self.karmaLevel = dict["karmaLevel"] as? Int
        self.kills = dict["kills"] as? Int
        self.krakenCaptures = dict["krakenCaptures"] as? Int
        self.level = dict["level"] as? Int
        self.minionKills = dict["minionKills"] as? Int
        self.nonJungleMinionKills = dict["nonJungleMinionKills"] as? Int
        self.skillTier = dict["skillTier"] as? Int
        self.skin = Skin(id: dict["skin"] as? String ?? "", type: .skin)
        self.turretCaptures = dict["turretCaptures"] as? Int
        self.wentAfk = dict["wentAfk"] as? Bool
        self.winner = dict["winner"] as? Bool
        self.isUser = dict["isUser"] as? Bool
        self.player = Player(dict: dict["player"] as? [String: Any] ?? [String: Any]())
        self.playerName = dict["playerName"] as? String
        self.playerWinsString = dict["playerWinsString"] as? String
        self.itemObjects = (dict["itemObjects"] as? [String] ?? [""]).map { Item(id: $0, type: .item) }
        super.init(dict: dict)
    }
    
    required init(id: String, type: ModelType) {
        super.init(id: id, type: type)
    }
    
    override var encoded: [String : Any?] {
        let dict: [String: Any?] = [
            "id": id,
            "type": type,
            "actor": actor?.id,
            "shardId": shardId,
            "assists": assists,
            "crystalMineCaptures": crystalMineCaptures,
            "deaths": deaths,
            "farm": farm,
            "firstAfkTime": firstAfkTime,
            "gold": gold,
            "goldMineCaptures": goldMineCaptures,
            "itemGrants": itemGrants?.stats,
            "itemSells": itemSells?.stats,
            "itemUses": itemUses?.stats,
            "items": items,
            "jungleKills": jungleKills,
            "karmaLevel": karmaLevel,
            "kills": kills,
            "krakenCaptures": krakenCaptures,
            "level": level,
            "minionKills": minionKills,
            "nonJungleMinionKills": nonJungleMinionKills,
            "skillTier": skillTier,
            "skin": skin?.id,
            "turretCaptures": turretCaptures,
            "wentAfk": wentAfk,
            "winner": winner,
            "isUser": isUser,
            "player": player?.encoded,
            "playerName": playerName,
            "playerWinsString": playerWinsString,
            "itemObjects": itemObjects?.map { $0.id }
        ]
        return dict
    }
}

