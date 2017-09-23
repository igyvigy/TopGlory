//
//  MatchTableViewCell.swift
//  TopGlory
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class MatchTableViewCell: TGTableViewCell {

    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var gameModeLabel: UILabel!
    @IBOutlet weak var endGameReasonLabel: UILabel!
    @IBOutlet weak var queueLabel: UILabel!
    
    @IBOutlet var rosterViews: [RosterView]!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        rosterViews.forEach {
            $0.prepareForReuse()
        }
    }
    
    func update(with match: Match) {
        createdAtLabel.text = match.createdAt?.timeFromNow()
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
