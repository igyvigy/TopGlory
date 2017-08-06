//
//  Participant.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

class ItemStatsModel: Model {
    var name: String
    var count: Int
    
    init (name: String, count: Int) {
        self.name = name
        self.count = count
        super.init(json: JSON.null)
    }
    
    required convenience init(json: JSON, included: [Model]?) {
        self.init(json: json, included: included)
        name = ""
        count = 0
    }
}

class ItemStats {
    var stats: [String: Int]
    init(json: JSON) {
        let statsDict = json.dictionaryValue
        stats = [String: Int]()
        for key in statsDict.keys {
            stats[key] = statsDict[key]?.intValue
        }
    }
    
}
class ItemGrants: ItemStats {}
class ItemSells: ItemStats {}
class ItemUses: ItemStats {}

class Participant: Model {
    var actor: String?
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
    var skinKey: String?
    var turretCaptures: Int?
    var wentAfk: Bool?
    var winner: Bool?
    
    private var related = [Model]()
    
    public var player: Player? {
        return related
            .filter({ $0.type == "player" })
            .map({ Player(model: $0) })
            .first
    }
    
    var playerName: String {
        let key = "participant\(id ?? "").playerName"
        if let catched = Catche.runtimeString[key] {
            return catched
        } else {
            let playerName = player?.name ?? ""
            Catche.runtimeString[key] = playerName
            return playerName
        }
    }
    
    var isUser: Bool {
        return playerName == AppConfig.currentUserName
    }
    init (model: Model) {
        super.init(id: model.id, type: model.type, attributes: model.attributes, relationships: model.relationships)
        decode()
    }
    
    required init(json: JSON, included: [Model]? = nil) {
        super.init(json: json, included: included)
    }
    
    private func decode() {
        guard let att = self.attributes as? JSON else { return }
        self.actor = att["actor"].string
        self.shardId = att["shardId"].string
        self.assists = att["stats"]["assists"].int
        self.crystalMineCaptures = att["stats"]["crystalMineCaptures"].int
        self.deaths = att["stats"]["deaths"].int
        self.farm = att["stats"]["farm"].double
        self.firstAfkTime = att["stats"]["firstAfkTime"].int
        self.gold = att["stats"]["gold"].double
        self.goldMineCaptures = att["stats"]["goldMineCaptures"].int
        self.itemGrants = ItemGrants(json: att["stats"]["itemGrants"])
        self.itemSells = ItemSells(json: att["stats"]["itemSells"])
        self.itemUses = ItemUses(json: att["stats"]["itemUses"])
        self.items = att["stats"]["items"].arrayValue.map({ $0.stringValue })
        self.jungleKills = att["stats"]["jungleKills"].int
        self.karmaLevel = att["stats"]["karmaLevel"].int
        self.kills = att["stats"]["kills"].int
        self.krakenCaptures = att["stats"]["krakenCaptures"].int
        self.level = att["stats"]["level"].int
        self.minionKills = att["stats"]["minionKills"].int
        self.nonJungleMinionKills = att["stats"]["nonJungleMinionKills"].int
        self.skillTier = att["stats"]["skillTier"].int
        self.skinKey = att["stats"]["skinKey"].string
        self.turretCaptures = att["stats"]["turretCaptures"].int
        self.wentAfk = att["stats"]["wentAfk"].bool
        self.winner = att["stats"]["winner"].bool
        guard let rels = self.relationships, rels.categories?.count ?? 0 > 0 else { return }
        related = []
        rels.categories?.forEach({
            related.append(contentsOf: $0.data ?? [Model]())
        })
        let _ = playerName
    }
}
