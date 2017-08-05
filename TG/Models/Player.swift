//
//  Player.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SeasonStats {
    struct Season {
        var number: Int
        var value: Double
        init(number: Int, value: Double) {
            self.number = number
            self.value = value
        }
    }
    static let firstSeasonNumber: Int = 4
    static let lastSeasonNumber: Int = 7
    
    var data: [Season]
    
    init(json: JSON) {
        var data = [Season]()
        for number in SeasonStats.firstSeasonNumber...SeasonStats.lastSeasonNumber {
            data.append(Season(
                number: number,
                value: json["stats"]["elo_earned_season_\(number)"].doubleValue
            ))
        }
        self.data = data
    }
}

class Player: Model {
    var name: String?
    var shardId: String?
    var seasonStats: SeasonStats?
    var karmaLevel: Int?
    var level: Int?
    var lifetimeGold: Double?
    var lossStreak: Int?
    var played: Int?
    var played_ranked: Int?
    var skillTier: Int?
    var winStreak: Int?
    var wins: Int?
    var xp: Int?
    
    private var related = [Model]()
    
    public var assets: [Model] {
        return related.filter({ $0.type == "asset" })
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
        self.name = att["name"].string
        self.shardId = att["shardId"].string
        self.seasonStats = SeasonStats(json: att)
        self.karmaLevel = att["stats"]["karmaLevel"].int
        self.level = att["stats"]["level"].int
        self.lifetimeGold = att["stats"]["lifetimeGold"].double
        self.lossStreak = att["stats"]["lossStreak"].int
        self.played = att["stats"]["played"].int
        self.played_ranked = att["stats"]["played_ranked"].int
        self.skillTier = att["stats"]["skillTier"].int
        self.winStreak = att["stats"]["winStreak"].int
        self.wins = att["stats"]["wins"].int
        self.xp = att["stats"]["xp"].int
        guard let rels = self.relationships, rels.categories?.count ?? 0 > 0 else { return }
        related = []
        rels.categories?.forEach({
            related.append(contentsOf: $0.data ?? [Model]())
        })
    }
}
