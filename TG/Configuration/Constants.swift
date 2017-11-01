//
//  Constants.swift
//  TopGlory
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

typealias TGOwner = UIViewController
typealias Completion = () -> Void
typealias Handler = () -> Void
typealias StringCompletion = (String) -> Void
typealias DateCompletion = (Date) -> Void


struct Constants {
    static let lastUserDefaultsKey = "lastPlayerName"
    static let shardDefaultsKey = "shardDefaultsKey"
    static let kUploadsImagesPath = "uploads/images"
    static let kUploadsVideosPath = "uploads/videos"
    static let kNumberOfDaysToSearchMatches = 27
}

let kEmptyStringValue = ""
