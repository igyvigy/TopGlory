//
//  Model.swift
//  TG
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

enum ModelType: String {
    case skin = "Skin"
    case actor = "Actor"
    case item = "Item"
    case unknown = "Unknown"
    case gamemode = "GameMode"
    
    var nameUrlInsertion: (String) -> (name: String?, url: String?) {
        switch self {
        case .skin:
            return { id in
                let skin = AppConfig.current.skinCatche[id]
                if skin?.url == nil {
                    FirebaseHelper.storeUnknownSkinIdentifier(skinIdentifier: id)
                }
                return (skin?.name, skin?.url)
            }
        case .actor:
            return { id in
                let actor = AppConfig.current.actorCatche[id]
                if actor?.url == nil {
                    FirebaseHelper.storeUnknownActorIdentifier(actorIdentifier: id)
                }
                return (actor?.name ?? id.chopPrefix().chopSuffix(), actor?.url)
            }
        case .item:
            return { id in
                if let existingItem = AppConfig.current.items.filter({ item -> Bool in
                    return item.itemStatsId == id
                }).first {
                    return (existingItem.name, existingItem.url)
                } else if let item = AppConfig.current.itemCatche[id] {
                    if let url = item.url {
                        return (item.name, url)
                    } else {
                        FirebaseHelper.storeUnknownItemIdentifier(itemIdentifier: id)
                        
                        return (item.name, nil)
                    }
                } else {
                    FirebaseHelper.storeUnknownItemIdentifier(itemIdentifier: id)
                    
                    return (id, nil)
                }
            }
        case .gamemode:
            return { id in
                let gameMode = AppConfig.current.gameModeCatche[id]
                if gameMode?.name == nil {
                    FirebaseHelper.storeUnknownGameModeIdentifier(gameModeIdentifier: id)
                }
                return (gameMode?.name, gameMode?.url)
            }
        default: return { _ in return (nil, nil) }
        }
    }
}

class Model {
    var id: String?
    var type: String?
    var name: String?
    var url: String?
    
    var modelType: ModelType {
        return ModelType(rawValue: type ?? "") ?? .unknown
    }
    
    required init (dict: [String: Any?]) {
        self.id = dict["id"] as? String
        self.type = dict["type"] as? String
    }
    
    required init(id: String, type: ModelType) {
        self.id = id
        self.type = type.r
        
        let insertion = type.nameUrlInsertion(id)
        self.name = insertion.name
        self.url = insertion.url
    }
    var encoded: [String : Any?] {
        return [
            "id": id,
            "type": type,
            "name": name,
            "url": url
        ]
    }
}
