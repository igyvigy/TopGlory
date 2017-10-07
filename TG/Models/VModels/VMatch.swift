//
//  VMatch.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class VMatch: VModel {
    public var gameMode: GameMode?
    public var titleId: String?
    public var createdAt: Date?
    public var patchVersion: String?
    public var shardId: String?
    public var duration: Int?
    
    public var endGameReason: String?
    public var queue: String?
    
    private var related = [VModel]()
    public var assets: [VAsset] {
        return related.filter({ $0.type == "asset" }).map({ VAsset(model: $0) })
    }
    public var rosters: [VRoster] {
        return related.filter({ $0.type == "roster" }).map({ VRoster(model: $0) })
    }
    public var rounds: [VModel] {
        return related.filter({ $0.type == "rounds" })
    }
    public var spectators: [VModel] {
        return related.filter({ $0.type == "spectators" })
    }
    public var description: String {
        let key = "match\(id ?? "").description"
        if let catched = Catche.runtimeString[key] {
            return catched
        } else {
            let description = "\(gameMode?.name ?? "") · \(rosters.filter({ $0.isUserTeam }).first?.won ?? false ? "you won" : "you lost")"
            Catche.runtimeString[key] = description
            return description
        }
    }
    
    var userWon: Bool {
        return rosters.filter({ $0.isUserTeam }).first?.won ?? false
    }
    
    init(model: VModel) {
        super.init(id: model.id, type: model.type, attributes: model.attributes, relationships: model.relationships)
        decode()
    }
    
    required init(json: JSON, included: [VModel]? = nil) {
        super.init(json: json, included: included)
        decode()
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
    
    private func decode() {
        guard let att = self.attributes as? JSON else { return }
        self.gameMode = GameMode(id: att["gameMode"].string ?? "", type: .gamemode)
        self.titleId = att["titleId"].string
        self.createdAt = (att["createdAt"].string?.dateFromISO8601WithoutTimeZone ?? Date())
        self.patchVersion = att["patchVersion"].string
        self.shardId = att["shardId"].string
        self.endGameReason = att["stats"]["endGameReason"].string
        self.queue = att["stats"]["queue"].string
        self.duration = att["duration"].int
        guard let rels = self.relationships, rels.categories?.count ?? 0 > 0 else { return }
        related = []
        rels.categories?.forEach({
            related.append(contentsOf: $0.data ?? [VModel]())
        })
        let _ = description
    }
}

extension VMatch {
    class func findWhere(withOwner owner: TGOwner? = nil,
                         userName: String? = nil,
                         stardDate: Date? = TGDates.last24Hours.now,
                         endDate: Date? = Calendar.current.date(byAdding: DateComponents(second: -1), to: Date())!,
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
        let operation = JSONAPIArrayOperation<VMatch>(
            with: router,
            completion: APIManager.resultHandlerService().completionForArray(
                withOwner: owner,
                loaderMessage: loaderMessage,
                control: control,
                onSuccess: { matches in
                    onSuccess( matches.map { match in Match(dict: match.encoded) } )
            },
                onError: onError))
        APIManager.operationQueue().addOperation(operation)
    }
    
    func fetch(withOwner owner: TGOwner? = nil,
               loaderMessage: String? = nil,
               control: Control? = nil,
               onSuccess: @escaping (VMatch) -> Void,
               onError: Completion? = nil) {
        let parameters: Parameters = [:]
        let router = Router.match(id: id ?? "",parameters: parameters)
        let operation = JSONAPIObjectOperation<VMatch>(
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
