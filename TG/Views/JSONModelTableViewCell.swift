//
//  JSONModelTableViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 7/13/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class JSONModelTableViewCell: UITableViewCell {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var fieldStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with model: Model) {
        appendField(key: "type", val: model.type ?? "none")
        appendField(key: "id", val: model.id ?? "none")
        guard let attributes = model.parseAttributes() else { return }
        for (key, value) in attributes {
            appendField(key: key, val: value)
        }
    }
    
    private func appendField(key: String, val: Any) {
        guard mainStackView.arrangedSubviews.filter({ ($0 as? UILabel)?.text == key }).count == 0 else { return }
        let keyLabel = UILabel()
        keyLabel.text = key
        keyLabel.textColor = .lightGray
        let valLabel = UILabel()
        valLabel.text = String(describing: val)
        valLabel.textColor = .darkGray
        let stackView = UIStackView(arrangedSubviews: [keyLabel, valLabel])

        mainStackView.addArrangedSubview(stackView)
        
    }
}
