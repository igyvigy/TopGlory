//
//  ParticipantTableViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class ParticipantTableViewCell: TGTableViewCell {
    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var actorLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var afkStampView: UIView!
    @IBOutlet weak var afkStampLabel: UILabel!
    @IBOutlet weak var afkStampImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var participant: Participant? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }
    
    func update(with participant: Participant?, showPlayer: Bool = false) {
        guard let participant = participant else { return }
        if self.participant?.id != participant.id {
            self.participant = participant
        }
        if collectionView.numberOfItems(inSection: 0) == 0 {
            collectionView.reloadData()
        }
        let actor = participant.actor
        let player = participant.playerName ?? ""
        var text = (participant.isUser ?? false) ? " (you) \(actor?.name ?? "")" : actor?.name
        if showPlayer { text = player + " " + text! }
        actorLabel.text = text
        if let skinUrl = URL(string: participant.skin?.url ?? "") {
            actorImageView.setImage(withURL: skinUrl)
        } else if let url = URL(string: participant.actor?.url ?? "") {
            actorImageView.setImage(withURL: url)
        }
        rankLabel.text = "#\(participant.skillTier ?? 0)"
        winsLabel.text = participant.playerWinsString
        killsLabel.text = "\(participant.kills ?? 0)"
        deathsLabel.text = "\(participant.deaths ?? 0)"
        assistsLabel.text = "\(participant.assists ?? 0)"
        afkStampView.isHidden = !(participant.wentAfk ?? false)
        afkStampLabel.text = participant.firstAfkTime?.secondsFormatted
        guard !showPlayer else {
            stackView.configureViews(for: [5,6,7,8,9,10,11], isHidden: true, animated: false, completion: {})
            return }
        stackView.configureViews(for: [5,6,7,8,9,10,11], isHidden: false, animated: false, completion: {})
        crystalCaptureLabel.text = "\(participant.crystalMineCaptures ?? 0)"
        goldCaptureLabel.text = "\(participant.goldMineCaptures ?? 0)"
        krakenCaptureLabel.text = "\(participant.krakenCaptures ?? 0)"
        goldLabel.text = String(format: "%.0f", participant.gold ?? 0)
        farmLabel.text = "\(participant.farm ?? 0)"
        turretsLabel.text = "\(participant.turretCaptures ?? 0)"
        minionAllLabel.text = "\(participant.minionKills ?? 0)"
        minionLaneLabel.text = "\(participant.nonJungleMinionKills ?? 0)"
        minionJungleLabel.text = "\(participant.jungleKills ?? 0)"
        
    }
}

extension ParticipantTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participant?.itemObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        cell.update(with: participant?.itemObjects?[safe: indexPath.row])
        return cell
    }
}

extension ParticipantTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = participant?.itemObjects?.count ?? 0
        let cellWidth = 50
        let cellSpacing = 10
        let totalCellWidth = cellWidth * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)
        
        var leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth))
        if leftInset < 0 { leftInset = 0 }
        return UIEdgeInsetsMake(0, leftInset, 0, 0)
    }
}
