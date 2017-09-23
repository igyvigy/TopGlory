//
//  Roster.swift
//  TG
//
//  Created by Andrii Narinian on 7/12/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import SwiftyJSON

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

class VRoster: VModel {
    var won: Bool?
    var acesEarned: Int?
    var gold: Int?
    var heroKills: Int?
    var krakenCaptures: Int?
    var side: Side?
    var turretKills: Int?
    var turretsRemaining: Int?
    
    private var related = [VModel]()
    
    public var participants: [VParticipant] {
        return related.filter({ $0.type == "participant" }).map({ VParticipant(model: $0) })
    }
    public var team: [VModel] {
        return related.filter({ $0.type == "team" })
    }
    var isUserTeam: Bool {
        let key = "roster\(id ?? "").isUserTeam"
        if let catched = Catche.runtimeBool[key] {
            return catched
        } else {
            let isUserTeam = participants
                .filter({ $0.player?.name == AppConfig.currentUserName })
                .count > 0
            Catche.runtimeBool[key] = isUserTeam
            return isUserTeam
        }
    }
    init (model: VModel) {
        super.init(id: model.id, type: model.type, attributes: model.attributes, relationships: model.relationships)
        decode()
    }
    public var partisipantActors: [Actor] {
        let key = "roster\(id ?? "").partisipantsString"
        if let catched = Catche.runtimeAny[key] {
            return catched as! [Actor]
        } else {
            let description = participants
                .map({ $0.actor })
            Catche.runtimeAny[key] = description
            return description as! [Actor]
        }
    }
    
    required init(json: JSON, included: [VModel]? = nil) {
        super.init(json: json, included: included)
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
            "participants": participants.map { $0.encoded },
            "isUserTeam": isUserTeam,
            "partisipantActors": partisipantActors.map { $0.id }
        ]
        return dict
    }
    
    private func decode() {
        guard let att = self.attributes as? JSON else { return }
        self.won = att["won"].string == "true" ? true : false
        self.acesEarned = att["stats"]["acesEarned"].int
        self.gold = att["stats"]["gold"].int
        self.heroKills = att["stats"]["heroKills"].int
        self.krakenCaptures = att["stats"]["krakenCaptures"].int
        self.side = Side(string: att["stats"]["side"].string)
        self.turretKills = att["stats"]["turretKills"].int
        self.turretsRemaining = att["stats"]["turretsRemaining"].int
        guard let rels = self.relationships, rels.categories?.count ?? 0 > 0 else { return }
        related = []
        rels.categories?.forEach({
            if $0.data?.count ?? 0 > 0 {
                related.append(contentsOf: $0.data ?? [VModel]())
            }
        })
        let _ = isUserTeam
        let _ = partisipantActors
    }
}
