//
//  ParticipantDetailViewController.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import Hero

class ParticipantDetailViewController: TableViewController {
    class func deploy(with participant: Participant) -> ParticipantDetailViewController {
        let vc = ParticipantDetailViewController.instantiateFromStoryboardId(.main)
        vc.participant = participant
        return vc
    }
    
    var participant: Participant!
    var models: [Model] {
        let itemUses = participant.itemUses?.stats.map({ ItemStatsModel(name: $0.key, count: $0.value) })
        var data = [participant.player!, participant] as [Model]
        if let itemUses = itemUses, itemUses.count > 0 {
            data.append(contentsOf: itemUses as [Model])
        }
        return data
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        super.viewDidLoad()
    }
}

extension ParticipantDetailViewController: TableViewControllerDataSource {
    var _cellIdentifiers: [UITableViewCell.Type] {
        return [ParticipantTableViewCell.self, PlayerTableViewCell.self, UsedItemTableViewCell.self]
    }
    
    var _tableView: UITableView {
        return tableView
    }
    
    var _models: [Model] {
        return models
    }
}

extension ParticipantDetailViewController: TableViewControllerDelegate {
    func cell(for model: Model, at indexPath: IndexPath) -> UITableViewCell? {
        if let player = model as? Player {
            let cell = PlayerTableViewCell.dequeued(by: tableView)
            cell.update(with: player)
            return cell
        }
        if let participant = model as? Participant {
            let cell = ParticipantTableViewCell.dequeued(by: tableView)
            cell.update(with: participant)
            return cell
        }
        if let itemStatsModel = model as? ItemStatsModel {
            let cell = UsedItemTableViewCell.dequeued(by: tableView)
            let dropppedFirstSeven = itemStatsModel.name.chopPrefix(7).chopSuffix()
            if let item = Array(Item.cases())
                .filter({ $0.rawValue.contains(dropppedFirstSeven) })
                .first {
                cell.update(
                    with: item.name,
                    imageString: item.imageUrl,
                    count: itemStatsModel.count
                )
            } else {
                cell.update(
                    with: itemStatsModel.name,
                    imageString: Item.oakheart.imageUrl,
                    count: itemStatsModel.count
                )
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func didSelect(_ model: Model, at indexPath: IndexPath) {
        
    }
}
