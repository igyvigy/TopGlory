//
//  HeaderTableViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/7/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class HeaderTableViewCell: TGTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func update(with title: String?) {
        titleLabel.text = title
    }
}
