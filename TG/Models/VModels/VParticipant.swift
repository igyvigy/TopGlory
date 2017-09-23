//
//  VParticipant.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

extension ItemStats {
    convenience init(json: JSON) {
        let statsDict = json.dictionaryValue
        var stats = [String: Int]()
        for key in statsDict.keys {
            stats[key] = statsDict[key]?.intValue
        }
        self.init(stats: stats)
    }
}

class VParticipant: VModel {
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
    
    private var related = [VModel]()
    
    public var player: VPlayer? {
        return related
            .filter({ $0.type == "player" })
            .map({ VPlayer(model: $0) })
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
    
    var playerWinsString: String {
        let key = "participant\(id ?? "").playerVinsString"
        if let catched = Catche.runtimeString[key] {
            return catched
        } else {
            var percentOfWins: String {
                let played = Double(player?.played ?? 0)
                let won = Double(player?.wins ?? 0)
                let percent = won/played*100
                let formated = String(format: "%.0f", percent)
                return percent <= 100 ? "wins: \(won) " + "(" + formated + "%" + ")" : "wins: \(won)"
            }
            Catche.runtimeString[key] = percentOfWins
            return percentOfWins
        }
    }
    var itemObjects: [Item] {
        let key = "participant\(id ?? "").items"
        if let catched = Catche.runtimeAny[key] {
            return catched as! [Item]
        } else {
            let itemz = Array(AppConfig.current.itemCatche.values)
                .filter({ self.items?.contains($0.name ?? "") ?? false })
            Catche.runtimeAny[key] = itemz
            return itemz
        }
    }
    var isUser: Bool {
        return playerName == AppConfig.currentUserName
    }
    init (model: VModel) {
        super.init(id: model.id, type: model.type, attributes: model.attributes, relationships: model.relationships)
        decode()
    }
    
    required init(json: JSON, included: [VModel]? = nil) {
        super.init(json: json, included: included)
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
            "itemObjects": itemObjects.map { $0.id }
        ]
        return dict
    }
    
    private func decode() {
        guard let att = self.attributes as? JSON else { return }
        self.actor = Actor(string: att["actor"].stringValue)
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
        self.skin = Skin(id: att["stats"]["skinKey"].stringValue)
        self.turretCaptures = att["stats"]["turretCaptures"].int
        self.wentAfk = att["stats"]["wentAfk"].bool
        self.winner = att["stats"]["winner"].bool
        guard let rels = self.relationships, rels.categories?.count ?? 0 > 0 else { return }
        related = []
        rels.categories?.forEach({
            related.append(contentsOf: $0.data ?? [VModel]())
        })
        let _ = playerName
    }
}
