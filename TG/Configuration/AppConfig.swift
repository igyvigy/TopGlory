
//
//  AppConfig.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

enum Shard: String, EnumCollection {
    case  northAmerica = "na",
    europe = "eu",
    southAmerica = "sa",
    eastAsia = "ea",
    southeastAsia = "sg",
    tournamentNa = "tournament-na",
    tournamentEu = "tournament-eu",
    tournamentSa = "tournament-sa",
    tournamentEa = "tournament-ea",
    tournamentSg = "tournament-sg"
    
    var name: String {
        switch self {
        case .northAmerica: return "North America"
        case .europe: return "Europe"
        case .southAmerica: return "South America"
        case .eastAsia: return "East Asia"
        case .southeastAsia: return "Southeast Asia"
        case .tournamentNa: return "North America Tournaments"
        case .tournamentEu: return "Europe Tournaments"
        case .tournamentSa: return "South America Tournaments"
        case .tournamentEa: return "East Asia Tournaments"
        case .tournamentSg: return "Southeast Asia Tournaments"
        }
    }
}

struct AppConfig {
    
    static let API_URL = "https://api.dc01.gamelockerapp.com/shards"
    static let apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwZjRiNWQ0MC00NzhkLTAxMzUtZTJhOC0wMjQyYWMxMTAwMDYiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNDk5Njg0NDkzLCJwdWIiOiJzZW1jIiwidGl0bGUiOiJ2YWluZ2xvcnkiLCJhcHAiOiIwZjQ5YTYzMC00NzhkLTAxMzUtZTJhNi0wMjQyYWMxMTAwMDYiLCJzY29wZSI6ImNvbW11bml0eSIsImxpbWl0IjoxMH0.MTXzY-WjXJtj30nBKnU9xf8hIj6FkMEAJtkKDfeXJbY"
    static var currentUserName: String? {
        return UserDefaults.standard.string(forKey: Constants.lastUserDefaultsKey)
    }
    static var currentShardId: String {
        return UserDefaults.standard.string(forKey: Constants.shardDefaultsKey) ?? "eu"
    }
    
    static var current: AppConfig = { return AppConfig() }()
    
    private init(){}
    
    var skinCatche: [AnyHashable: Skin] = [:]
    var abilityCatche: [AnyHashable: Ability] = [:]
    var actorCatche: [AnyHashable: Actor] = [:]
    var itemCatche: [AnyHashable: Item] = [:]
    var gameModeCatche: [AnyHashable: GameMode] = [:]
    var skinUnknownCatche: [AnyHashable: String] = [:]
    var abilityUnknownCatche: [AnyHashable: String] = [:]
    var actorUnknownCatche: [AnyHashable: String] = [:]
    var itemUnknownImageCatche: [AnyHashable: String] = [:]
    var itemUnknownIdentifierCatche: [AnyHashable: String] = [:]
    var gameModeUnknownCatche: [AnyHashable: String] = [:]
    
    var skins: [Skin] {
        return Array(skinCatche.values).sorted(by: { $0.id ?? "" < $1.id ?? "" })
    }
    var abilities: [Ability] {
        return Array(abilityCatche.values).sorted(by: { $0.id ?? "" < $1.id ?? "" })
    }
    var actors: [Actor] {
        return Array(actorCatche.values).sorted(by: { $0.id ?? "" < $1.id ?? "" })
    }
    var items: [Item] {
        return Array(itemCatche.values).sorted(by: { $0.id ?? "" < $1.id ?? "" })
    }
    var gameModes: [GameMode] {
        return Array(gameModeCatche.values).sorted(by: { $0.id ?? "" < $1.id ?? "" })
    }
    var newSkins: [String] {
        return Array(skinUnknownCatche.values).sorted(by: { $0 < $1 })
    }
    var newActors: [String] {
        return Array(actorUnknownCatche.values).sorted(by: { $0 < $1 })
    }
    var newItemImages: [String] {
        return Array(itemUnknownImageCatche.values).sorted(by: { $0 < $1 })
    }
    var newItemIds: [String] {
        return Array(itemUnknownIdentifierCatche.values).sorted(by: { $0 < $1 })
    }
    var newGameModes: [String] {
        return Array(gameModeUnknownCatche.values).sorted(by: { $0 < $1 })
    }
    
    var finishedToFetchData = false {
        didSet {
            print("finishedToFetchData: \(finishedToFetchData)")
        }
    }
    
    func getCatche(with type: ModelType) -> [AnyHashable: Any] {
        switch type {
        case .skin: return skinCatche
        case .actor: return actorCatche
        case .item: return itemCatche
        case .unknown: return [:]
        case .gamemode: return gameModeCatche
        case .ability: return abilityCatche
        }
    }
    
    mutating func fetchAll(completion: @escaping () -> Void) {
        clearStorage()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        fetchData(isFinal: false) {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchUnknownData(isFinal: false) {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            AppConfig.current.finishedToFetchData = true
            completion()
        }
    }
    
    mutating func clearStorage() {
        skinCatche = [:]
        actorCatche = [:]
        itemCatche = [:]
        gameModeCatche = [:]
        skinUnknownCatche = [:]
        actorUnknownCatche = [:]
        itemUnknownImageCatche = [:]
        itemUnknownIdentifierCatche = [:]
        gameModeUnknownCatche = [:]
    }
    
    func fetchData(isFinal: Bool = true, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        fetchActors {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchItems {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchGameModes {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchSkins {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            if isFinal {
                AppConfig.current.finishedToFetchData = true
            }
            completion()
        }
    }
    
    func fetchUnknownData(isFinal: Bool = true, completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        fetchUnknownActors {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchUnknownItemImages {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchUnknownItemIdentifiers {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchUnknownGameModes {
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        fetchUnknownSkins {
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            if isFinal {
                AppConfig.current.finishedToFetchData = true
            }
            completion()
        }
    }
}

fileprivate extension AppConfig {
    func fetchSkins(completion: @escaping () -> Void) {
        FirebaseHelper.getAllSkins { skins in
            skins.forEach { AppConfig.current.skinCatche[$0.id ?? ""] = $0 }
            completion()
        }
    }
    func fetchActors(completion: @escaping () -> Void) {
        FirebaseHelper.getAllActors { actors in
            actors.forEach { AppConfig.current.actorCatche[$0.id ?? ""] = $0 }
            completion()
        }
    }
    func fetchGameModes(completion: @escaping () -> Void) {
        FirebaseHelper.getAllGameModes { gameModes in
            gameModes.forEach { AppConfig.current.gameModeCatche[$0.id ?? ""] = $0 }
            completion()
        }
    }
    func fetchItems(completion: @escaping () -> Void) {
        FirebaseHelper.getAllItems { items in
            items.forEach { AppConfig.current.itemCatche[$0.id ?? ""] = $0 }
            completion()
        }
    }
    func fetchUnknownActors(completion: @escaping () -> Void) {
        FirebaseHelper.getAllUnknownActors { actorIds in
            actorIds.forEach { AppConfig.current.actorUnknownCatche[$0] = $0 }
            completion()
        }
    }
    func fetchUnknownItemImages(completion: @escaping () -> Void) {
        FirebaseHelper.getAllUnknownItemImages { itemIds in
            itemIds.forEach { AppConfig.current.itemUnknownImageCatche[$0] = $0 }
            completion()
        }
    }
    func fetchUnknownItemIdentifiers(completion: @escaping () -> Void) {
        FirebaseHelper.getAllUnknownItemIdentifiers { itemIds in
            itemIds.forEach { AppConfig.current.itemUnknownIdentifierCatche[$0] = $0 }
            completion()
        }
    }
    func fetchUnknownGameModes(completion: @escaping () -> Void) {
        FirebaseHelper.getAllUnknownGameModes { gameModIds in
            gameModIds.forEach { AppConfig.current.gameModeUnknownCatche[$0] = $0 }
            completion()
        }
    }
    func fetchUnknownSkins(completion: @escaping () -> Void) {
        FirebaseHelper.getAllUnknownSkins { actorIds in
            actorIds.forEach { AppConfig.current.skinUnknownCatche[$0] = $0 }
            completion()
        }
    }
}
