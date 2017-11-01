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
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var acesLabel: UILabel!
    @IBOutlet weak var heroKillsLabel: UILabel!
    @IBOutlet weak var krakenCapturesLabel: UILabel!
    @IBOutlet weak var turretsKilledLabel: UILabel!
    @IBOutlet weak var turretsRemainsLabel: UILabel!
    @IBOutlet weak var yourTeamLabel: UILabel!
    @IBOutlet var participantsImageViews: [UIImageView]!
    @IBOutlet var playerNamesLabels: [UILabel]!
    
    func prepareForReuse() {
//        participantsImageViews.forEach { imageView in
//            imageView.layer.removeAllAnimations()
//            imageView.image = nil
//            imageView.af_cancelImageRequest()
//        }
    }
    
    func update(with roster: Roster?) {
        guard let roster = roster else { return }
        victoryLabel.text = roster.won ?? false ? "won" : "lost"
        backView.backgroundColor = roster.side?.color.uiColor
        goldLabel.text = "\(roster.gold ?? 0)"
        acesLabel.text = "\(roster.acesEarned ?? 0)"
        heroKillsLabel.text = "\(roster.heroKills ?? 0)"
        krakenCapturesLabel.text = "\(roster.krakenCaptures ?? 0)"
        turretsKilledLabel.text = "\(roster.turretKills ?? 0)"
        turretsRemainsLabel.text = "\(roster.turretsRemaining ?? 0)"
        
        yourTeamLabel.isHidden = !(roster.isUserTeam ?? false)
        guard let participants = roster.participants else { return }
        for (idx, participant) in participants.enumerated() {
            participantsImageViews[safe: idx]?.image = nil
            if let skinUrl = URL(string: participant.actor?.url ?? "") {
                participantsImageViews[safe: idx]?.setImage(withURL: skinUrl)
            }
            playerNamesLabels[safe: idx]?.text = participant.playerName
        }
    }
}
