//
//  Match.swift
//  TG
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum GameMode: String {
    case casual_aral, casual, ranked, blitz_pvp_ranked
    var description: String {
        switch self {
        case .casual: return "casual match"
        case .casual_aral: return "royal battle"
        case .ranked: return "ranked match"
        case .blitz_pvp_ranked: return "blitz pvp"
        default: return self.rawValue
        }
    }
}

class Match: Model {
    public var gameMode: GameMode?
    public var titleId: String?
    public var createdAt: String?
    public var patchVersion: String?
    public var shardId: String?
    public var duration: Int?
    
    public var endGameReason: String?
    public var queue: String?
    
    private var related = [Model]()
    public var assets: [Asset] {
        return related.filter({ $0.type == "asset" }).map({ Asset(model: $0) })
    }
    public var rosters: [Roster] {
        return related.filter({ $0.type == "roster" }).map({ Roster(model: $0) })
    }
    public var rounds: [Model] {
        return related.filter({ $0.type == "rounds" })
    }
    public var spectators: [Model] {
        return related.filter({ $0.type == "spectators" })
    }
    public var description: String {
        let key = "match\(id ?? "").description"
        if let catched = Catche.runtimeString[key] {
            return catched
        } else {
            let description = "\(gameMode?.description ?? "") · \(rosters.filter({ $0.isUserTeam }).first?.won ?? false ? "you won" : "you lost")"
            Catche.runtimeString[key] = description
            return description
        }
    }
    init(model: Model) {
        super.init(id: model.id, type: model.type, attributes: model.attributes, relationships: model.relationships)
        decode()
    }
    
    required init(json: JSON, included: [Model]? = nil) {
        super.init(json: json, included: included)
        decode()
    }
    
    private func decode() {
        guard let att = self.attributes as? JSON else { return }
        self.gameMode = GameMode(rawValue: att["gameMode"].string ?? "")
        self.titleId = att["titleId"].string
        self.createdAt = att["createdAt"].string
        self.patchVersion = att["patchVersion"].string
        self.shardId = att["shardId"].string
        self.endGameReason = att["stats"]["endGameReason"].string
        self.queue = att["stats"]["queue"].string
        self.duration = att["duration"].int
        guard let rels = self.relationships, rels.categories?.count ?? 0 > 0 else { return }
        related = []
        rels.categories?.forEach({
            related.append(contentsOf: $0.data ?? [Model]())
        })
        let _ = description
    }
}

extension Match {
    class func findWhere(withOwner owner: TGOwner? = nil,
                         userName: String? = nil,
                         stardDate: Date? = TGDates.last24Hours.now,
                         endDate: Date? = Date(),
                         loaderMessage: String? = nil,
                         control: Control? = nil,
                         onSuccess: @escaping ([Match]) -> Void,
                         onError: Completion? = nil) {
        let parameters: Parameters = [
            "filter[playerNames]": userName ?? "null",
            "filter[createdAt-start]": stardDate?.iso8601 ?? "null",
            "filter[createdAt-end]": endDate?.iso8601 ?? "null",
            "sort": "-createdAt"
        ]
        print(parameters)
        let router = Router.matches(parameters: parameters)
        let operation = JSONAPIArrayOperation<Match>(
            with: router,
            completion: APIManager.resultHandlerService().completionForArray(
                withOwner: owner,
                loaderMessage: loaderMessage,
                control: control,
                onSuccess: onSuccess,
                onError: onError))
        APIManager.operationQueue().addOperation(operation)
    }
    
    func fetch(withOwner owner: TGOwner? = nil,
               loaderMessage: String? = nil,
               control: Control? = nil,
               onSuccess: @escaping (Match) -> Void,
               onError: Completion? = nil) {
        let parameters: Parameters = [:]
        let router = Router.match(id: id ?? "",parameters: parameters)
        let operation = JSONAPIObjectOperation<Match>(
            with: router,
            completion: APIManager.resultHandlerService().completionForObject(
                withOwner: owner,
                loaderMessage: loaderMessage,
                control: control,
                onSuccess: onSuccess,
                onError: onError))
        APIManager.operationQueue().addOperation(operation)
    }
}
