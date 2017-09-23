//
//  PlayerTableViewCell.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

class PlayerTableViewCell: TGTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var karmaLevelLabel: UILabel!
    @IBOutlet weak var lifetimeGoldLabel: UILabel!
    @IBOutlet weak var lossStreakLabel: UILabel!
    @IBOutlet weak var playedLabel: UILabel!
    @IBOutlet weak var played_rankedLabel: UILabel!
    @IBOutlet weak var skillTierLabel: UILabel!
    @IBOutlet weak var winStreakLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var player: FPlayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
    }
    
    func update(with player: FPlayer) {
        self.player = player
        tableView.reloadData()
        nameLabel.text = player.name
        levelLabel.text = "\(player.level ?? 0)"
        karmaLevelLabel.text = "\(player.karmaLevel ?? 0)"
        lifetimeGoldLabel.text = "\(player.lifetimeGold ?? 0)"
        lossStreakLabel.text = "\(player.lossStreak ?? 0)"
        playedLabel.text = "\(player.played ?? 0)"
        played_rankedLabel.text = "ranked: \(player.played_ranked ?? 0)"
        skillTierLabel.text = "\(player.skillTier ?? 0)"
        winStreakLabel.text = "\(player.winStreak ?? 0)"
        winsLabel.text = "\(player.wins ?? 0) " + percentOfWins
        xpLabel.text = "\(player.xp ?? 0)"
    }
    
    var percentOfWins: String {
        let played = Double(player?.played ?? 0)
        let won = Double(player?.wins ?? 0)
        let percent = won/played*100
        let formated = String(format: "%.0f", percent)
        return "(" + formated + "%" + ")"
    }
}

extension PlayerTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return player?.seasonStats?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TGTableViewCell(style: .value1, reuseIdentifier: "statCell")
        let season = player?.seasonStats?.data[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = "elo earned during season \(season?.number ?? 0)"
        cell.detailTextLabel?.text = String(format: "%.3f", season?.value ?? 0)
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .lightGray
        cell.contentView.backgroundColor = .almostBlack
        return cell
    }
}
