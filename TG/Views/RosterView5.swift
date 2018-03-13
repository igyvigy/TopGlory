//
//  RosterView.swift
//  TG
//
//  Created by Andrii Narinian on 7/14/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class RosterView5: NibLoadingView {
    @IBOutlet weak var victoryLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var acesLabel: UILabel!
    @IBOutlet weak var heroKillsLabel: UILabel!
    @IBOutlet weak var krakenCapturesLabel: UILabel!
    @IBOutlet weak var turretsKilledLabel: UILabel!
    @IBOutlet weak var turretsRemainsLabel: UILabel!
    @IBOutlet weak var yourTeamLabel: UILabel!
//    @IBOutlet var participantsImageViews: [UIImageView]!
//    @IBOutlet var playerNamesLabels: [UILabel]!
    @IBOutlet weak var playerImagesStackView: UIStackView!
    @IBOutlet weak var playerNamesStackView: UIStackView!
    
    func prepareForReuse() {
//        playerImagesStackView.arrangedSubviews.forEach { playerImagesStackView.removeArrangedSubview($0) }
//        playerNamesStackView.arrangedSubviews.forEach { playerNamesStackView.removeArrangedSubview($0) }
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
        if playerImagesStackView.arrangedSubviews.count == 0 {
            fillStackViews(with: participants)
        } else {
            updateStackViews(with: participants)
        }
    }
    
    private func updateStackViews(with participants: [Participant]) {
        for (idx, participant) in participants.enumerated() {
            if let imageView = playerImagesStackView.arrangedSubviews[safe: idx] as? UIImageView {
                update(imageView: imageView, with: participant)
            }
            if let label = playerNamesStackView.arrangedSubviews[safe: idx] as? UILabel {
                label.text = participant.playerName
            }
        }
    }
    
    private func update(imageView: UIImageView, with participant: Participant) {
        imageView.image = nil
        if let skinUrl = URL(string: participant.actor?.url ?? "") {
            imageView.setImage(withURL: skinUrl)
        }
    }
    
    private func fillStackViews(with participants: [Participant]) {
        participants.forEach { participant in
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            update(imageView: imageView, with: participant)
            playerImagesStackView.addArrangedSubview(imageView)
            let label = UILabel()
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.2
            label.text = participant.playerName
            playerNamesStackView.addArrangedSubview(label)
        }
    }
}
