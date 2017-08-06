//
//  ItemCollectionViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import AlamofireImage

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var reusableImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with item: Item?) {
        guard let url = URL(string: item?.imageUrl ?? "") else { return }
        reusableImageView.af_setImage(withURL: url)
    }
}
