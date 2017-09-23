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
    static var actorsReference = ref.child("public/actors")
    static var itemsReference = ref.child("public/items")
    static var historyReference = ref.child("history")
    
    static func configure() {
        FirebaseApp.configure()
    }
    
    static func createRecordsForKnownSkins() {
        processSkins(Array(SkinType.cases())) {
            print("skins processing finished")
        }
    }
    
    static func createRecordsForKnownActors() {
        processActors(Array(Actor.cases())) {
            print("actors processing finished")
        }
    }
    
    static func createRecordsForKnownItems() {
        processItems(Array(Item.cases())) {
            print("items processing finished")
        }
    }
    
    static func storeUnknownSkinIdentifier(skinIdentifier: String) {
        updateValues(on: unknownSkinsReference, values: [skinIdentifier: skinIdentifier])
    }
    
    static func save(model: VModel) {
        guard let currentUserName = AppConfig.currentUserName else { return }
        let values = model.encoded
        updateValues(
            on: historyReference
                .child(currentUserName)
                .child(model.type ?? "no_type")
                .child(model.id ?? "no_id"),
            values: values
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
    
    static func existsForCurrentUser(model: VModel, completion: @escaping (Bool) -> Void) {
        guard let currentUserName = AppConfig.currentUserName else {
            completion(false)
            
            return }
        historyReference
            .child(currentUserName)
            .child(model.type ?? "no_type")
            .child(model.id ?? "no_id")
            .observeSingleEvent(of: .value, with: { snap in
            DispatchQueue.main.async {
                completion(snap.exists())
            }
        })
    }
    
}

fileprivate extension FirebaseHelper {
    static func processItems(_ items: [Item], completion: @escaping () -> Void) {
        items.forEach { item in
            updateValues(on: itemsReference.child(item.r), values: [
                "id": item.r,
                "name": item.name,
                "url": item.imageUrl ?? "null",
                "category": item.category.r,
                "tier": item.tier.r,
                "price": item.price
                ])
        }
        completion()
    }
    
    static func processSkins(_ skins: [SkinType], completion: @escaping () -> Void) {
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
        uploadImage(skin.image, completion: { (url, image, _) in
            guard let url = url, let _ = image else {
                processSkins(skins, completion: completion)
                
                return }
            updateValues(on: skinsReference.child(skin.r), values: ["url": url.absoluteString])
            if skins.isEmpty {
                completion()
            } else {
                processSkins(skins, completion: completion)
            }
        })
    }
    
    static func processActors(_ actors: [Actor], completion: @escaping () -> Void) {
        actors.forEach { actor in
            guard let imageUrl = actor.imageUrl else { return }
            updateValues(on: actorsReference.child(actor.r), values: [
                "id": actor.r,
                "name": actor.name,
                "url": imageUrl
                ])
        }
        completion()
    }
    
    static func updateValues(on ref: DatabaseReference, values: [AnyHashable : Any]) {
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
