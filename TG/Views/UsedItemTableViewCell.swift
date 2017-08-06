//
//  UsedItemTableViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import AlamofireImage

class UsedItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemUsageLabel: UILabel!
    
    func update(with name: String, imageString: String, count: Int) {
        if let url = URL(string: imageString) {
            itemImageView.af_setImage(withURL: url)
        }
        itemNameLabel.text = name
        itemUsageLabel.text = "used \(count) times"
    }
    
}
