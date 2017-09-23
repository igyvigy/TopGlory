//
//  DocumentsHelper.swift
//  Rolique
//
//  Created by Andrii Narinian on 9/12/17.
//  Copyright © 2017 Rolique. All rights reserved.
//

import UIKit

class ImageViewCatche {
    static let current = ImageViewCatche()
    private init() {}
    private let isUsingPersistence = true
    private var _runtimeCatche = [URL: Image]()
    func imageFor(_ url: URL) -> Image? {
        if let imageFromCatche = _runtimeCatche[url] {
            return imageFromCatche
        } else if isUsingPersistence {
            if let image = DocumentsHelper.getImageFromCatche(withUrl: url) {
                _runtimeCatche[url] = image
                return image
            } else { return nil }
        } else { return nil }
    }
    func save(_ image: Image?) {
        guard let image = image, let url = image.imageUrl else { return }
        if _runtimeCatche[url] != nil {
            return
        } else {
            _runtimeCatche[url] = image
            if isUsingPersistence {
                DispatchQueue.global(qos: .background).async {
                    DocumentsHelper.saveToImageCatche(image: image)
                }
            }
        }
    }
}

class DocumentsHelper {
    
    private static let accessTokenKey = "Access_Token", refreshTokenKey = "Refresh_Token"
    private struct DBKeys {
        static let catchedImages = "/imageCatche/"
    }
    
    static func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //print("documents directory:\n\(paths[0])\n")
        return paths[0]
    }
    
    private static func standardDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    static func save(catchedImages: [URL: UIImage]) -> Bool {
        let manager = FileManager()
        if !manager.fileExists(atPath: getDocumentsDirectory() + DBKeys.catchedImages, isDirectory: nil) {
            try! manager.createDirectory(atPath: getDocumentsDirectory() + DBKeys.catchedImages, withIntermediateDirectories: true, attributes: nil)
        }
        var result = false
        for (url, image) in catchedImages {
            result = NSKeyedArchiver.archiveRootObject(image, toFile: getDocumentsDirectory() + DBKeys.catchedImages + url.lastPathComponent)
        }
        return result
    }
    
    @discardableResult static func saveToImageCatche(image: Image) -> Bool {
        guard let img = image.image, let url = image.imageUrl else { return false }
        let manager = FileManager()
        if !manager.fileExists(atPath: getDocumentsDirectory() + DBKeys.catchedImages, isDirectory: nil) {
            try! manager.createDirectory(atPath: getDocumentsDirectory() + DBKeys.catchedImages, withIntermediateDirectories: true, attributes: nil)
        }
        return NSKeyedArchiver.archiveRootObject(img, toFile: getDocumentsDirectory() + DBKeys.catchedImages + url.lastPathComponent)
    }
    
    static func getImageFromCatche(withUrl url: URL) -> Image? {
        if let img = NSKeyedUnarchiver.unarchiveObject(withFile: getDocumentsDirectory() + DBKeys.catchedImages + url.lastPathComponent) as? UIImage {
            return Image(uiImage: img, url: url)
        }
        return nil
    }
}
