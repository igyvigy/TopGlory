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
    static var unknownSkinsReference = ref.child("public/unknown_skins")
    static var unknownActorsReference = ref.child("public/unknown_actors")
    static var unknownItemsReference = ref.child("public/unknown_items")
    static var unknownGameModesReference = ref.child("public/unknown_game_modes")
    static var unknownItemStatsIdReference = ref.child("public/unknown_item_stats_id")
    static var actorsReference = ref.child("public/actors")
    static var itemsReference = ref.child("public/items")
    static var gameModesReference = ref.child("public/game_mode")
    static var historyReference = ref.child("history")
    
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
    
    static func update(image: UIImage, for skin: Skin, completion: @escaping () -> Void) {
        processSkins([(skin, image)], completion: completion)
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
        uploadImage(skin.1, completion: { (url, image, _) in
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
    
    static func processActors(_ actors: [ActorType], completion: @escaping () -> Void) {
        actors.forEach { actor in
            updateValues(on: actorsReference.child(actor.r), values: [
                "id": actor.r,
                "name": actor.name,
                "url": actor.imageUrl
                ])
        }
        completion()
    }
    
    static func updateValues(on ref: DatabaseReference, values: [AnyHashable : Any?]) {
        ref.updateChildValues(values)
    }
    
    static func uploadImage(_ image: UIImage?, completion: @escaping StorageHelper.UploadImageInfoCompletion) {
        guard let image = image else {
            completion(StorageHelper.UploadImageInfo(nil, nil, nil))
            
            return
        }
        StorageHelper.uploadImage(image, completion: completion)
    }
}
