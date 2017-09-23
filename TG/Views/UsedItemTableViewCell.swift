//
//  UsedItemTableViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class UsedItemTableViewCell: TGTableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemUsageLabel: UILabel!
    
    func update(with name: String, imageString: String, count: Int, type: ItemStatsModelType) {
        if let url = URL(string: imageString) {
            itemImageView.setImage(withURL: url)
        }
        itemNameLabel.text = name
        var action = ""
        switch type {
        case .itemGrants: action = "purchased"
        case .itemUses: action = "used"
        case .itemSells: action = "sold"
        default: break
        }
        itemUsageLabel.text = "\(action) \(count) times"
    }
    
}
