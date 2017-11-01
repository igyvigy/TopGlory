//
//  VRoster.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON

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
        return participants
            .filter({ $0.player?.name == AppConfig.currentUserName })
            .count > 0
    }
    init (model: VModel) {
        super.init(id: model.id, type: model.type, attributes: model.attributes, relationships: model.relationships)
        decode()
    }
    public var partisipantActors: [Actor] {
        return participants.flatMap { $0.actor }
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
