//
//  RosterTableViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class RosterTableViewCell: TGTableViewCell {
    @IBOutlet weak var victoryLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var acesLabel: UILabel!
    @IBOutlet weak var heroKillsLabel: UILabel!
    @IBOutlet weak var krakenCapturesLabel: UILabel!
    @IBOutlet weak var turretsKilledLabel: UILabel!
    @IBOutlet weak var turretsRemainsLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    func update(with roster: FRoster?) {
        guard let roster = roster else { return }
        let text = roster.won ?? false ? "winner" : "looser"
        victoryLabel.text = (roster.isUserTeam ?? false) ? text + " (your team)" : text
        backView.backgroundColor = roster.side?.color.uiColor
        goldLabel.text = "\(roster.gold ?? 0)"
        acesLabel.text = "\(roster.acesEarned ?? 0)"
        heroKillsLabel.text = "\(roster.heroKills ?? 0)"
        krakenCapturesLabel.text = "\(roster.krakenCaptures ?? 0)"
        turretsKilledLabel.text = "\(roster.turretKills ?? 0)"
        turretsRemainsLabel.text = "\(roster.turretsRemaining ?? 0)"
    }
}
