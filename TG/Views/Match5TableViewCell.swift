//
//  Match5TableViewCell.swift
//  TG
//
//  Created by Andrii on 3/8/18.
//  Copyright © 2018 ROLIQUE. All rights reserved.
//

import UIKit

class Match5TableViewCell: TGTableViewCell {
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var gameModeLabel: UILabel!
    @IBOutlet weak var endGameReasonLabel: UILabel!
    @IBOutlet weak var queueLabel: UILabel!
    
    @IBOutlet var rosterViews: [RosterView5]!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        rosterViews.forEach {
            $0.prepareForReuse()
        }
    }
    
    func update(with match: Match) {
        createdAtLabel.text = DateFormatterHelper.messageString(from: match.createdAt!)
        durationLabel.text = match.duration?.secondsFormatted
        gameModeLabel.text = match.description
        gameModeLabel.textColor = match.userWon ?? false ? .green : .red
        endGameReasonLabel.text = match.endGameReason
        queueLabel.text = match.queue
        
        guard match.rosters.count > 1 else { return }
        rosterViews[0].update(with: match.rosters[safe: 0])
        rosterViews[1].update(with: match.rosters[safe: 1])
    }
}
