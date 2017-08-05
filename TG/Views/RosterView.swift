//
//  RosterView.swift
//  TG
//
//  Created by Andrii Narinian on 7/14/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class RosterView: NibLoadingView {
    @IBOutlet weak var victoryLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var acesLabel: UILabel!
    @IBOutlet weak var heroKillsLabel: UILabel!
    @IBOutlet weak var krakenCapturesLabel: UILabel!
    @IBOutlet weak var turretsKilledLabel: UILabel!
    @IBOutlet weak var turretsRemainsLabel: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var yourTeamLabel: UILabel!
    
    func update(with roster: Roster?) {
        guard let roster = roster else { return }
        victoryLabel.text = roster.won ?? false ? "\n\n\nwon" : "\n\n\nlost"
        victoryLabel.backgroundColor = roster.side?.color.uiColor
        goldLabel.text = "\(roster.gold ?? 0)"
        acesLabel.text = "\(roster.acesEarned ?? 0)"
        heroKillsLabel.text = "\(roster.heroKills ?? 0)"
        krakenCapturesLabel.text = "\(roster.krakenCaptures ?? 0)"
        turretsKilledLabel.text = "\(roster.turretKills ?? 0)"
        turretsRemainsLabel.text = "\(roster.turretsRemaining ?? 0)"
        participantsLabel.text = roster.participants
            .flatMap({ $0.actor })
            .reduce("", {$0 == "" ? $1 : $0 + "," + $1})
        yourTeamLabel.isHidden = !roster.isUserTeam
    }
}
