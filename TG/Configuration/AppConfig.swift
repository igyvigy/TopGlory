
//
//  AppConfig.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

struct AppConfig {
    static let API_URL = "https://api.dc01.gamelockerapp.com/shards"
    static let apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIwZjRiNWQ0MC00NzhkLTAxMzUtZTJhOC0wMjQyYWMxMTAwMDYiLCJpc3MiOiJnYW1lbG9ja2VyIiwiaWF0IjoxNDk5Njg0NDkzLCJwdWIiOiJzZW1jIiwidGl0bGUiOiJ2YWluZ2xvcnkiLCJhcHAiOiIwZjQ5YTYzMC00NzhkLTAxMzUtZTJhNi0wMjQyYWMxMTAwMDYiLCJzY29wZSI6ImNvbW11bml0eSIsImxpbWl0IjoxMH0.MTXzY-WjXJtj30nBKnU9xf8hIj6FkMEAJtkKDfeXJbY"
    static var currentUserName: String? {
        return UserDefaults.standard.string(forKey: Constants.lastUserDefaultsKey)
    }
    static var current: AppConfig = { return AppConfig() }()
    
    private init(){}
    
    var skinCatche: [AnyHashable: Skin] = [:] {
        didSet {
            print("skinCatche: \(skinCatche)")
        }
    }
    var actorCatche: [AnyHashable: Actor] = [:] {
        didSet {
            print("actorCatche: \(actorCatche)")
        }
    }
    var itemCatche: [AnyHashable: Item] = [:] {
        didSet {
            print("itemCatche: \(itemCatche)")
        }
    }
    var gameModeCatche: [AnyHashable: GameMode] = [:] {
        didSet {
            print("gameModeCatche: \(gameModeCatche)")
        }
    }
    var finishedToFetchData = false {
        didSet {
            print("finishedToFetchData: \(finishedToFetchData)")
        }
    }
    
    func fetchData(completion: @escaping () -> Void) {
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
            AppConfig.current.finishedToFetchData = true
            completion()
        }
    }
    
    fileprivate func fetchSkins(completion: @escaping () -> Void) {
        FirebaseHelper.getAllSkins { skins in
            skins.forEach { AppConfig.current.skinCatche[$0.id ?? ""] = $0 }
            completion()
        }
    }
    
    fileprivate func fetchActors(completion: @escaping () -> Void) {
        FirebaseHelper.getAllActors { actors in
            actors.forEach { AppConfig.current.actorCatche[$0.id ?? ""] = $0 }
            completion()
        }
    }
    
    fileprivate func fetchGameModes(completion: @escaping () -> Void) {
        FirebaseHelper.getAllGameModes { gameModes in
            gameModes.forEach { AppConfig.current.gameModeCatche[$0.id ?? ""] = $0 }
            completion()
        }
    }
    
    fileprivate func fetchItems(completion: @escaping () -> Void) {
        FirebaseHelper.getAllItems { items in
            items.forEach { AppConfig.current.itemCatche[$0.id ?? ""] = $0 }
            completion()
        }
    }
}
