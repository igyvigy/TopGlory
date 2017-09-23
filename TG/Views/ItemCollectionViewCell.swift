//
//  ItemCollectionViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var reusableImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with item: Item?) {
        guard let url = URL(string: item?.url ?? "") else { return }
        reusableImageView.setImage(withURL: url)
    }
}
