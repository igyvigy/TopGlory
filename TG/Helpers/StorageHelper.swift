//
//  StorageHelper.swift
//  Rolique
//
//  Created by Bohdan Savych on 9/6/17.
//  Copyright © 2017 Rolique. All rights reserved.
//

import FirebaseStorage
import UIKit

final class StorageHelper {
    fileprivate static var storageRef: StorageReference {
        return Storage.storage().reference()
    }
    
    typealias UploadImageInfo = (url: URL?, image: UIImage?, progress: Double?)
    typealias UploadImageInfoCompletion = (UploadImageInfo) -> Void
    typealias UploadVideoInfo = (url: URL?, progress: Double?)
    typealias UploadVideoInfoCompletion = (UploadVideoInfo) -> Void
    
    static func uploadImage(_ image: UIImage, trackProgress: Bool = false, completion: @escaping UploadImageInfoCompletion) {
        DispatchQueue.global(qos: .default).async {
            guard let data = image.png else {
                
                return
            }
            
            DispatchQueue.main.async {
                let fileName = "\(NSUUID().uuidString).jpg"
                let uploadTask = StorageHelper.storageRef.child(Constants.kUploadsImagesPath).child(fileName).putData(data, metadata: nil, completion: { metadata, _ in
                    if let imageUrl = URL(string: metadata?.downloadURLs?.first?.absoluteString ?? kEmptyStringValue) {
                        completion(UploadImageInfo(url: imageUrl, image: image, progress: nil))
                    }

                })
                
                if trackProgress {
                    uploadTask.observe(.progress, handler: { snapshot in
                        completion(UploadImageInfo(url: nil, image: image, progress: snapshot.progress?.fractionCompleted ?? 0))
                    })
                }
            }
        }

    }
    
    static func uploadVideo(_ url: URL, trackProgress: Bool = false, completion: @escaping UploadVideoInfoCompletion) {
        DispatchQueue.global(qos: .default).async {
            if let data = try? Data(contentsOf: url, options: .mappedIfSafe) {
                DispatchQueue.main.async {
                    let fileName = "\(NSUUID().uuidString).mov"
                    let uploadTask = StorageHelper.storageRef.child(Constants.kUploadsVideosPath).child(fileName).putData(data, metadata: nil, completion: { metadata, _ in
                        if let videoUrl = URL(string: metadata?.downloadURLs?.first?.absoluteString ?? kEmptyStringValue) {
                            completion(UploadVideoInfo(videoUrl, progress: nil))
                        }
                    })
                    
                    if trackProgress {
                        uploadTask.observe(.progress, handler: { snapshot in
                            completion(UploadVideoInfo(url: nil, progress: snapshot.progress?.fractionCompleted ?? 0))
                        })
                    }
                }
            }
        }
    }
    
//    static func loadImage(withUrl url: String, completion: @escaping (Image?) -> Void) {
//        let storageRef = Storage.storage().reference()
//        let imagesRef = storageRef.child(url)
//        
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        imagesRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
//            guard let data = data, let image = UIImage(data: data), error == nil else {
//                completion(nil)
//                
//                return
//            }
//            
//            let im = Image(uiImage: image, url: url)
//            completion(im)
//        }
//    }
}
