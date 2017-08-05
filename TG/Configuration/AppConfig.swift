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
        return UserDefaults.standard.string(forKey: "lastPlayerName")
    }
}
