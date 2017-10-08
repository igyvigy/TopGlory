//
//  Match.swift
//  TG
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

class GameMode: Model {

    required init(dict: [String : Any?]) {
        
        super.init(dict: dict)
        type = "GameMode"
        name = dict["name"] as? String
        id = dict["id"] as? String
    }
    
    required init(id: String, type: ModelType) {
        super.init(id: id, type: type)
    }
    
    override var encoded: [String : Any?] {
        return [
            "name": name,
            "id": id,
            "type": type
        ]
    }
}

enum GameModeType: String {
    case casual_aral, casual, ranked, blitz_pvp_ranked
    var description: String {
        switch self {
        case .casual: return "casual match"
        case .casual_aral: return "royal battle"
        case .ranked: return "ranked match"
        case .blitz_pvp_ranked: return "blitz pvp"
        }
    }
}

class Match: Model, Equatable, Comparable {
    var gameMode: GameMode?
    var titleId: String?
    var createdAt: Date?
    var patchVersion: String?
    var shardId: String?
    var duration: Int?
    var endGameReason: String?
    var queue: String?
    var rosters = [Roster]()
    var assets = [Asset]()
    var description: String?
    var userWon: Bool?
    
    required init(dict: [String: Any?]) {
        self.gameMode = GameMode(id: dict["gameMode"] as? String ?? kEmptyStringValue, type: .gamemode)
        
        self.titleId = dict["titleId"] as? String
        self.createdAt = TGDateFormats.iso8601WithoutTimeZone.date(from: dict["createdAt"] as? String ?? "")
        self.patchVersion = dict["patchVersion"] as? String
        self.shardId = dict["shardId"] as? String
        self.endGameReason = dict["endGameReason"] as? String
        self.queue = dict["queue"] as? String
        self.duration = dict["duration"] as? Int
        self.assets = (dict["assets"] as? [[String: Any]] ?? [[String: Any]]()).map { Asset(dict: $0) }
        self.rosters = (dict["rosters"] as? [[String: Any]] ?? [[String: Any]]()).map { Roster(dict: $0) }
        self.description = dict["description"] as? String
        self.userWon = dict["userWon"] as? Bool
        super.init(dict: dict)
    }
    
    required init(id: String, type: ModelType) {
        super.init(id: id, type: type)
    }
    
    override var encoded: [String : Any?] {
        let dict: [String: Any?] = [
            "id": id,
            "type": type,
            "gameMode": gameMode?.id,
            "titleId": titleId,
            "createdAt": TGDateFormats.iso8601WithoutTimeZone.string(from: createdAt ?? Date()),
            "patchVersion": patchVersion,
            "shardId": shardId,
            "endGameReason": endGameReason,
            "queue": queue,
            "duration": duration,
            "assets": assets.map { $0.encoded },
            "rosters": rosters.map { $0.encoded },
            "description": description,
            "userWon": userWon
        ]
        return dict
    }
}

func ==(lhs: Match, rhs: Match) -> Bool {
    return lhs.id == rhs.id
}
func <(lhs: Match, rhs: Match) -> Bool {
    return lhs.createdAt ?? Date() > rhs.createdAt ?? Date()
}
func <=(lhs: Match, rhs: Match) -> Bool {
    return lhs.createdAt ?? Date() >= rhs.createdAt ?? Date()
}
func >=(lhs: Match, rhs: Match) -> Bool {
    return lhs.createdAt ?? Date() <= rhs.createdAt ?? Date()
}
func >(lhs: Match, rhs: Match) -> Bool {
    return lhs.createdAt ?? Date() < rhs.createdAt ?? Date()
}
