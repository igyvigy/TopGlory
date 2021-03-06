//
//  FirebaseHelper.swift
//  TG
//
//  Created by Andrii Narinian on 9/22/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

class FirebaseHelper {
    static var ref = Database.database().reference()
    
    static var skinsReference = ref.child("public/skins")
    static var abilitiesReference = ref.child("public/abilities")
    static var otherReference = ref.child("public/other")
    static var actorsReference = ref.child("public/actors")
    static var itemsReference = ref.child("public/items")
    static var gameModesReference = ref.child("public/game_mode")
    static var historyReference = ref.child("history")
    
    static var unknownSkinsReference = ref.child("public/unknown_skins")
    static var unknownAbilitiesReference = ref.child("public/unknown_abilities")
    static var unknownOtherReference = ref.child("public/unknown_other")
    static var unknownActorsReference = ref.child("public/unknown_actors")
    static var unknownItemsReference = ref.child("public/unknown_items")
    static var unknownGameModesReference = ref.child("public/unknown_game_modes")
    static var unknownItemStatsIdReference = ref.child("public/unknown_item_stats_id")
    
    static func configure() {
        FirebaseApp.configure()
    }
    
    static func createRecordsForKnownActors() {
        processActors(Array(ActorType.cases())) {
            print("actors processing finished")
        }
    }
    
    static func createRecordsForKnownItems() {
        processItems(Array(ItemType.cases())) {
            print("items processing finished")
        }
    }
    
    static func store(skin: Skin) {
        let encoded = skin.encoded
        updateValues(on: skinsReference, values: encoded)
    }
    
    static func store(skins: [Skin], completion: @escaping () -> Void) {
        skins.forEach { skin in
            updateValues(on: skinsReference.child(skin.id ?? ""), values: skin.encoded)
        }
        completion()
    }
    
    static func store(models: [Model]) {
        models.forEach { model in
            switch model.modelType {
            case .skin:
                updateValues(on: skinsReference.child(model.id ?? "null"), values: model.encoded)
            case .ability:
                updateValues(on: abilitiesReference.child(model.id ?? "null"), values: model.encoded)
            case .actor:
                updateValues(on: actorsReference.child(model.id ?? "null"), values: model.encoded)
            case .item:
                updateValues(on: itemsReference.child(model.id ?? "null"), values: model.encoded)
            case .unknown:
                updateValues(on: otherReference.child(model.id ?? "null"), values: model.encoded)
            case .gamemode:
                updateValues(on: gameModesReference.child(model.id ?? "null"), values: model.encoded)
            }
        }
    }
    
    static func removeUnknownRecordForMode(model: Model, isItemStatsId: Bool = false) {
        switch model.modelType {
        case .skin:
            unknownSkinsReference.child(model.id ?? "null").removeValue()
        case .ability:
            unknownAbilitiesReference.child(model.id ?? "null").removeValue()
        case .actor:
            unknownActorsReference.child(model.id ?? "null").removeValue()
        case .item:
            if isItemStatsId {
                unknownItemStatsIdReference.child(model.id ?? "null").removeValue()
            } else {
                unknownItemsReference.child(model.id ?? "null").removeValue()
            }
        case .unknown:
            unknownOtherReference.child(model.id ?? "null").removeValue()
        case .gamemode:
            unknownGameModesReference.child(model.id ?? "null").removeValue()
        }
    }
    
//    static func storeUnknownModel(model: Model) {
//        switch model.modelType {
//        case .skin: updateValues(on: unknownSkinsReference, values: [model.id ?? "null": model.id])
//        case .actor: updateValues(on: unknownActorsReference, values: [model.id ?? "null": model.id])
//        case .item: updateValues(on: unknownItemsReference, values: [model.id ?? "null": model.id])
//        case .unknown: updateValues(on: unknownOtherReference, values: [model.id ?? "null": model.id])
//        case .gamemode: updateValues(on: unknownGameModesReference, values: [model.id ?? "null": model.id])
//        }
//    }
    
    static func storeUnknownSkinIdentifier(skinIdentifier: String) {
        updateValues(on: unknownSkinsReference, values: [skinIdentifier: skinIdentifier])
    }
    
    static func storeUnknownActorIdentifier(actorIdentifier: String) {
        updateValues(on: unknownActorsReference, values: [actorIdentifier: actorIdentifier])
    }
    
    static func storeUnknownGameModeIdentifier(gameModeIdentifier: String) {
        updateValues(on: unknownGameModesReference, values: [gameModeIdentifier: gameModeIdentifier])
    }
    
    static func storeUnknownItemIdentifier(itemIdentifier: String, isItemStatsId: Bool = false) {
        if isItemStatsId {
            updateValues(on: unknownItemStatsIdReference, values: [itemIdentifier: itemIdentifier])
        } else {
            updateValues(on: unknownItemsReference, values: [itemIdentifier: itemIdentifier])
        }
    }
    
    static func getAllDIfferentMatchesFromHistory(for matches: [Match], completion: @escaping ([Match]) -> Void) {
        guard let currentUserName = AppConfig.currentUserName else { return }
        historyReference
            .child(currentUserName)
            .child("match")
            .observeSingleEvent(of: .value, with: { snap in
                let allHistoryMatches = snap.children.map { child in
                    Match(dict: (child as? DataSnapshot)?.value as? [String: Any] ?? [String: Any]())
                }
                let fileterdMatches = allHistoryMatches.filter({ match -> Bool in
                    return !matches.contains(match)
                })
                DispatchQueue.main.async {
                    completion(fileterdMatches)
                }
            }
        )
    }
    
    static func getAllSkins(completion: @escaping ([Skin]) -> Void) {
        skinsReference
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion(snap.children.map { child in
                        Skin(dict: (child as? DataSnapshot)?.value as? [String: Any] ?? [String: Any]())
                    })
                }
            }
        )
    }
    
    static func getAllActors(completion: @escaping ([Actor]) -> Void) {
        actorsReference
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion(snap.children.map { child in
                        Actor(dict: (child as? DataSnapshot)?.value as? [String: Any] ?? [String: Any]())
                    })
                }
            }
        )
    }
    
    static func getAllUnknownActors(completion: @escaping ([String]) -> Void) {
        unknownActorsReference
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion(snap.children.map { child in
                        (child as? DataSnapshot)?.key ?? ""
                    })
                }
            }
        )
    }
    
    static func getAllItems(completion: @escaping ([Item]) -> Void) {
        itemsReference
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion(snap.children.map { child in
                        Item(dict: (child as? DataSnapshot)?.value as? [String: Any] ?? [String: Any]())
                    })
                }
            }
        )
    }
    
    static func getAllGameModes(completion: @escaping ([GameMode]) -> Void) {
        gameModesReference
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion(snap.children.map { child in
                        GameMode(dict: (child as? DataSnapshot)?.value as? [String: Any] ?? [String: Any]())
                    })
                }
            }
        )
    }
    
    static func getAllUnknownGameModes(completion: @escaping ([String]) -> Void) {
        unknownGameModesReference
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion(snap.children.map { child in
                        (child as? DataSnapshot)?.key ?? ""
                    })
                }
            }
        )
    }
    
    static func getAllUnknownSkins(completion: @escaping ([String]) -> Void) {
        unknownSkinsReference
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion(snap.children.map { child in
                        (child as? DataSnapshot)?.key ?? ""
                    })
                }
            }
        )
    }
    
    static func getAllUnknownItemImages(completion: @escaping ([String]) -> Void) {
        unknownItemsReference
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion(snap.children.map { child in
                        (child as? DataSnapshot)?.key ?? ""
                    })
                }
            }
        )
    }
    
    static func getAllUnknownItemIdentifiers(completion: @escaping ([String]) -> Void) {
        unknownItemStatsIdReference
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion(snap.children.map { child in
                        (child as? DataSnapshot)?.key ?? ""
                    })
                }
            }
        )
    }
    
    static func getSkin(with id: String, completion: @escaping (Skin) -> Void) {
        skinsReference
            .child(id)
            .observeSingleEvent(of: .value, with: { snap in
                DispatchQueue.main.async {
                    completion( Skin(dict: snap.value as? [String: Any] ?? [String: Any]()))
                }
            }
        )
    }
    
    static func update(image: UIImage, for model: Model, progressHandler: ((Float) -> Void)? = nil, completion: @escaping () -> Void) {
        processModels([(model, image)], progressHandler: progressHandler, completion: completion)
    }
    
    static func updateValues(on ref: DatabaseReference, values: [AnyHashable : Any?]) {
        ref.updateChildValues(values)
    }
}

fileprivate extension FirebaseHelper {
    static func processItems(_ items: [ItemType], completion: @escaping () -> Void) {
        items.forEach { item in
            updateValues(on: itemsReference.child(item.r), values: item.encoded)
        }
        completion()
    }
    
    static func processSkins(_ skins: [(Skin, UIImage)], completion: @escaping () -> Void) {
        //        skins.forEach { skin in
        //            updateValues(on: skinsReference.child(skin.r), values: ["id": skin.r])
        //        }
        //        completion()
        var skins = skins
        guard !skins.isEmpty else {
            completion()
            
            return
        }
        let skin = skins.removeFirst()
        uploadImage(skin.1, completion: { (url, image) in
            guard let url = url, let _ = image else {
                processSkins(skins, completion: completion)
                
                return }
            updateValues(on: skinsReference.child(skin.0.id ?? ""), values: ["url": url.absoluteString])
            if skins.isEmpty {
                completion()
            } else {
                processSkins(skins, completion: completion)
            }
        })
    }
    
    static func processModels(_ models: [(Model, UIImage)], progressHandler: ((Float) -> Void)? = nil, completion: @escaping () -> Void) {

        var models = models
        guard !models.isEmpty else {
            completion()
            
            return
        }
        let model = models.removeFirst()
        uploadImage(model.1, progressHandler: progressHandler, completion: { (url, image) in
            guard let url = url, let _ = image else {
                processModels(models, progressHandler: progressHandler, completion: completion)
                
                return }

            let model = model.0
            model.url = url.absoluteString
            store(models: [model])
            if models.isEmpty {
                completion()
            } else {
                processModels(models, progressHandler: progressHandler, completion: completion)
            }
        })
    }
    
    static func processActors(_ actors: [ActorType], completion: @escaping () -> Void) {
        actors.forEach { actor in
            updateValues(on: actorsReference.child(actor.r), values: [
                "id": actor.r,
                "url": actor.imageUrl
                ])
        }
        completion()
    }

    static func uploadImage(_ image: UIImage?, progressHandler: ((Float) -> Void)? = nil, completion: @escaping (URL?, UIImage?) -> Void) {
        guard let image = image else {
            completion(nil, nil)
            
            return
        }
        StorageHelper.uploadImage(image, progressHandler: progressHandler, completion: completion)
    }
}
