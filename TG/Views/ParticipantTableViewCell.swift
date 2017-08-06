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
     @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var participant: Participant?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
    }
    
    func update(with participant: Participant?, showPlayer: Bool = false) {
        guard let participant = participant else { return }
        self.participant = participant
        collectionView.reloadData()
        let actor = participant.actor
        let player = participant.playerName
        var text = participant.isUser ? " (you) \(actor ?? "")" : actor
        if showPlayer { text = player + " " + text! }
        actorLabel.text = text
        skinLabel.text = participant.skinKey
        killsLabel.text = "\(participant.kills ?? 0)"
        deathsLabel.text = "\(participant.deaths ?? 0)"
        assistsLabel.text = "\(participant.assists ?? 0)"
        guard !showPlayer else {
            stackView.configureViews(for: [4,5,6,7,8,9,10,11], isHidden: true, animated: false, completion: {})
            return }
        stackView.configureViews(for: [4,5,6,7,8,9,10,11], isHidden: false, animated: false, completion: {})
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

extension ParticipantTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participant?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        let itemName = participant?.items?[indexPath.row]
        let item = Array(Item.cases())
            .filter({ $0.name == itemName })
            .first
        cell.update(with: item)
        return cell
    }
}

extension ParticipantTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = participant?.items?.count ?? 0
        let cellWidth = 50
        let cellSpacing = 0
        let totalCellWidth = cellWidth * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)
        
        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }
}
