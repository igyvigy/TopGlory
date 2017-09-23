//
//  Image.swift
//  TG
//
//  Created by Andrii Narinian on 9/22/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

enum MediaType: String {
    case photo,
    video
}

struct Media {
    var type: MediaType = .photo
    var image: UIImage?
    var videoUrl: URL?
}

struct Image {
    var id: String { return imageUrl?.absoluteString ?? kEmptyStringValue }
    
    enum Fields: String {
        case type,
        image,
        width,
        height,
        urlString = "url",
        videoUrl = "video_url",
        imageUrl = "image_url"
    }
    
    var type: MediaType = .photo
    var image: UIImage?
    var width: CGFloat = 0
    var height: CGFloat = 0
    var videoUrl: URL?
    var imageUrl: URL?
    
    init(dict: [String : Any]) {
        type = MediaType(rawValue: (dict[Image.Fields.type.r] as? String ?? kEmptyStringValue)) ?? .photo
        width = dict[Image.Fields.width.r] as? CGFloat ?? 0
        height = dict[Image.Fields.height.r] as? CGFloat ?? 0
        videoUrl = URL(string: dict[Image.Fields.videoUrl.r] as? String ?? kEmptyStringValue)
        imageUrl = URL(string: dict[Image.Fields.imageUrl.r] as? String ?? kEmptyStringValue)
    }
    
    init(uiImage: UIImage, urlString: String, type: MediaType = .photo) {
        self.type = type
        width = uiImage.size.width
        height = uiImage.size.height
        image = uiImage
        videoUrl = nil
        imageUrl = URL(string: urlString)
    }
    
    init(media: Media, urlString: String) {
        type = media.type
        width = media.image?.size.width ?? 0
        height = media.image?.size.height ?? 0
        image = media.image
        videoUrl = media.videoUrl
        imageUrl = nil
    }
    
    var dict: [String: Any] {
        return [
            Image.Fields.type.r: type.rawValue,
            Image.Fields.width.r: width,
            Image.Fields.height.r: height,
            Image.Fields.videoUrl.r: (videoUrl?.absoluteString ?? kEmptyStringValue),
            Image.Fields.imageUrl.r: (imageUrl?.absoluteString ?? kEmptyStringValue)
        ]
    }
}
