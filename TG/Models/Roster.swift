//
//  Roster.swift
//  TG
//
//  Created by Andrii Narinian on 7/12/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class Roster: Model {
    var won: Bool?
    var acesEarned: Int?
    var gold: Int?
    var heroKills: Int?
    var krakenCaptures: Int?
    var side: Side?
    var turretKills: Int?
    var turretsRemaining: Int?
    var participants: [Participant]?
    var isUserTeam: Bool?
    var partisipantActors: [Actor]?
    
    required init(dict: [String: Any?]) {
        self.won = dict["won"] as? Bool
        self.acesEarned = dict["acesEarned"] as? Int
        self.gold = dict["gold"] as? Int
        self.heroKills = dict["heroKills"] as? Int
        self.krakenCaptures = dict["krakenCaptures"] as? Int
        self.side =  Side(identifier: dict["side"] as? String ?? "")
        self.turretKills = dict["turretKills"] as? Int
        self.turretsRemaining = dict["turretsRemaining"] as? Int
        self.participants = (dict["participants"] as? [[String: Any]] ?? [[String: Any]]()).map { Participant(dict: $0) }
        self.isUserTeam = dict["isUserTeam"] as? Bool
        self.partisipantActors = (dict["partisipantActors"] as? [String] ?? [String]()).map { Actor(string: $0) }
        super.init(dict: dict)
    }
    
    override var encoded: [String : Any?] {
        let dict: [String: Any?] = [
            "id": id,
            "type": type,
            "won": won,
            "acesEarned": acesEarned,
            "gold": gold,
            "heroKills": heroKills,
            "krakenCaptures": krakenCaptures,
            "side": side?.identifier,
            "turretKills": turretKills,
            "turretsRemaining": turretsRemaining,
            "participants": participants?.map { $0.encoded },
            "isUserTeam": isUserTeam,
            "partisipantActors": partisipantActors?.map { $0.id }
        ]
        return dict
    }
}
