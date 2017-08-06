//
//  ParticipantTableViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: UITableViewCell {
     @IBOutlet weak var actorLabel: UILabel!
     @IBOutlet weak var skinLabel: UILabel!
     @IBOutlet weak var killsLabel: UILabel!
     @IBOutlet weak var deathsLabel: UILabel!
     @IBOutlet weak var assistsLabel: UILabel!
     @IBOutlet weak var crystalCaptureLabel: UILabel!
     @IBOutlet weak var goldCaptureLabel: UILabel!
     @IBOutlet weak var krakenCaptureLabel: UILabel!
     @IBOutlet weak var goldLabel: UILabel!
     @IBOutlet weak var farmLabel: UILabel!
     @IBOutlet weak var turretsLabel: UILabel!
     @IBOutlet weak var minionAllLabel: UILabel!
     @IBOutlet weak var minionLaneLabel: UILabel!
     @IBOutlet weak var minionJungleLabel: UILabel!
     @IBOutlet weak var wentAfkLabel: UILabel!
     @IBOutlet weak var afkTimeLabel: UILabel!
     @IBOutlet weak var skillTierLabel: UILabel!
    
    func update(with participant: Participant?, showPlayer: Bool = false) {
        guard let participant = participant else { return }
        let actor = participant.actor
        let player = participant.playerName
        var text = participant.isUser ? " (you) \(actor ?? "")" : actor
        if showPlayer { text = player + " " + text! }
        actorLabel.text = text
        skinLabel.text = participant.skinKey
        killsLabel.text = "\(participant.kills ?? 0)"
        deathsLabel.text = "\(participant.deaths ?? 0)"
        assistsLabel.text = "\(participant.assists ?? 0)"
        crystalCaptureLabel.text = "\(participant.crystalMineCaptures ?? 0)"
        goldCaptureLabel.text = "\(participant.goldMineCaptures ?? 0)"
        krakenCaptureLabel.text = "\(participant.krakenCaptures ?? 0)"
        goldLabel.text = "\(participant.gold ?? 0)"
        farmLabel.text = "\(participant.farm ?? 0)"
        turretsLabel.text = "\(participant.turretCaptures ?? 0)"
        minionAllLabel.text = "\(participant.minionKills ?? 0)"
        minionLaneLabel.text = "\(participant.nonJungleMinionKills ?? 0)"
        minionJungleLabel.text = "\(participant.jungleKills ?? 0)"
        wentAfkLabel.text = "\(participant.wentAfk ?? false)"
        afkTimeLabel.text = "\(participant.firstAfkTime ?? 0)"
        skillTierLabel.text = "\(participant.skillTier ?? 0)"
    }
}
