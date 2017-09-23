//
//  Player.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

struct SeasonStats {
    struct Season {
        var number: Int
        var value: Double
        init?(number: Int, value: Double) {
            self.number = number
            self.value = value
        }
    }
    static let firstSeasonNumber: Int = 4
    static let lastSeasonNumber: Int = 7
    
    var data: [Season?]
    
    var encoded: [[String: Any]] {
        return data.map { ["\($0?.number ?? 0)": $0?.value ?? 0] }
    }
    
    init (dictArray: [[String: Any]]) {
        self.data = dictArray.map { dict in
            return Season(
                number: Int(dict.keys.first ?? "0") ?? 0,
                value: (dict[dict.keys.first ?? "0"] as? Double) ?? 0
            )
        }
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
    var assets: [Model]?
    
    required init(dict: [String : Any?]) {
        self.name = dict["name"] as? String
        self.shardId = dict["shardId"] as? String
        self.seasonStats = SeasonStats(dictArray: dict["seasonStats"] as? [[String : Any]] ?? [[String : Any]]())
        self.karmaLevel = dict["karmaLevel"] as? Int
        self.level = dict["level"] as? Int
        self.lifetimeGold = dict["lifetimeGold"] as? Double
        self.lossStreak = dict["lossStreak"] as? Int
        self.played = dict["played"] as? Int
        self.played_ranked = dict["played_ranked"] as? Int
        self.skillTier = dict["skillTier"] as? Int
        self.winStreak = dict["winStreak"] as? Int
        self.wins = dict["wins"] as? Int
        self.xp = dict["xp"] as? Int
        self.assets = (dict["assets"] as? [[String: Any]] ?? [[String: Any]]()).map { Model(dict: $0) }
        super.init(dict: dict)
    }
    
    override var encoded: [String : Any?] {
        let dict: [String: Any?] = [
            "id": id,
            "type": type,
            "name": name,
            "shardId": shardId,
            "seasonStats": seasonStats?.encoded,
            "karmaLevel": karmaLevel,
            "level": level,
            "lifetimeGold": lifetimeGold,
            "lossStreak": lossStreak,
            "played": played,
            "played_ranked": played_ranked,
            "skillTier": skillTier,
            "winStreak": winStreak,
            "wins": wins,
            "xp": xp,
            "assets": assets?.map { $0.encoded }
        ]
        return dict
    }
}
