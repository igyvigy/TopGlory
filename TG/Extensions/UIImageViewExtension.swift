//
//  UIImageViewExtension.swift
//  TG
//
//  Created by Andrii Narinian on 9/23/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {
    func setImage(withURL url: URL, completion: (() -> Void)? = nil) {
        image = nil
        if let catchedImage = ImageViewCatche.current.imageFor(url) {
            self.image = catchedImage.image
            completion?()
        } else {
            self.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: { progress in
                
            }, progressQueue: DispatchQueue.global(qos: .background), imageTransition: UIImageView.ImageTransition.crossDissolve(0.25), runImageTransitionIfCached: true) { responce in
                if let image = responce.value, let urlString = responce.request?.url?.absoluteString {
                    if urlString == url.absoluteString {
                        self.image = image
                        ImageViewCatche.current.save(Image(uiImage: image, url: url))
                        completion?()
                    }
                }
            }
        }
    }
}
