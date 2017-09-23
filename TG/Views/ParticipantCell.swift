//
//  ParticipantCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/12/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class ParticipantCell: TGTableViewCell {
    @IBOutlet weak var actorImageView: UIImageView!
    @IBOutlet weak var actorLabel: UILabel!
    
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var assistsLabel: UILabel!
    
    @IBOutlet weak var afkStampView: UIView!
    @IBOutlet weak var afkStampLabel: UILabel!
    @IBOutlet weak var afkStampImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var participant: FParticipant? {
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
    
    func update(with participant: FParticipant?) {
        guard let participant = participant else { return }
        if self.participant?.id != participant.id {
            self.participant = participant
        }
        if collectionView.numberOfItems(inSection: 0) == 0 {
            collectionView.reloadData()
        }
        let actor = participant.actor
        let player = participant.playerName ?? ""
        var text = (participant.isUser ?? false) ? " (you) \(actor?.rawValue ?? "")" : actor?.rawValue
        text = player + " " + (text ?? "")
        actorLabel.text = "#\(participant.skillTier ?? 0)  " + (text ?? "")
        if let skinUrl = URL(string: participant.skin?.url ?? "") {
            actorImageView.af_setImage(withURL: skinUrl)
        } else if let url = URL(string: participant.actor?.imageUrl ?? "") {
            actorImageView.af_setImage(withURL: url)
        }
        winsLabel.text = participant.playerWinsString
        killsLabel.text = "\(participant.kills ?? 0)"
        deathsLabel.text = "\(participant.deaths ?? 0)"
        assistsLabel.text = "\(participant.assists ?? 0)"
        
        afkStampView.isHidden = !(participant.wentAfk ?? false)
        afkStampLabel.text = participant.firstAfkTime?.secondsFormatted
    }
}

extension ParticipantCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participant?.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        cell.update(with: participant?.itemObjects?[safe: indexPath.row])
        return cell
    }
}

extension ParticipantCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = participant?.items?.count ?? 0
        let cellWidth = 50
        let cellSpacing = 10
        let totalCellWidth = cellWidth * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)
        
        var leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth))
        if leftInset < 0 { leftInset = 0 }
        return UIEdgeInsetsMake(0, leftInset, 0, 0)
    }
}
