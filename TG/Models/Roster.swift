//
//  Roster.swift
//  TG
//
//  Created by Andrii Narinian on 7/12/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import SwiftyJSON

enum SideDir {
    case left, right, none
}

enum SideColor {
    case red, blue, none
    
    var uiColor: UIColor {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .none: return .clear
        }
    }
}

struct Side {
    var dir: SideDir = .none
    var color: SideColor = .none
    
    init (stringValue: String?) {
        self.dir = stringValue?.range(of: "left") != nil ? .left : .right
        self.color = stringValue?.range(of: "blue") != nil ? .blue : .red
    }
}

class Roster: Model {
    var won: Bool?
    var acesEarned: Int?
    var gold: Int?
    var heroKills: Int?
    var krakenCaptures: Int?
    var side: Side?
    var turretKills: Int?
    var turretsRemaining: Int?
    
    private var related = [Model]()
    
    public var participants: [Participant] {
        return related.filter({ $0.type == "participant" }).map({ Participant(model: $0) })
    }
    public var team: [Model] {
        return related.filter({ $0.type == "team" })
    }
    var isUserTeam: Bool {
        return participants.filter({ $0.player?.name == AppConfig.currentUserName }).count > 0
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
        self.won = att["won"].string == "true" ? true : false
        self.acesEarned = att["stats"]["acesEarned"].int
        self.gold = att["stats"]["gold"].int
        self.heroKills = att["stats"]["heroKills"].int
        self.krakenCaptures = att["stats"]["krakenCaptures"].int
        self.side = Side(stringValue: att["stats"]["side"].string)
        self.turretKills = att["stats"]["turretKills"].int
        self.turretsRemaining = att["stats"]["turretsRemaining"].int
        guard let rels = self.relationships, rels.categories?.count ?? 0 > 0 else { return }
        related = []
        rels.categories?.forEach({
            if $0.data?.count ?? 0 > 0 {
                related.append(contentsOf: $0.data ?? [Model]())
            }
        })
    }
}
