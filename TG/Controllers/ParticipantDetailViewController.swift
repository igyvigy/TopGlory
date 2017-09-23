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
    var models = [Model]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        super.viewDidLoad()
        models = configureTableData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Hero.shared.setContainerColorForNextTransition(.black)
    }
    
    private func configureTableData() -> [Model] {
        var data = [participant.player!, participant] as [Model]
        let itemUses = participant.itemUses?.stats
            .map({ ItemStatsModel(name: $0.key, count: $0.value, modelType: .itemUses) })
        if let itemUses = itemUses, itemUses.count > 0 {
            let header = ItemStatsModel(name: "Used items".localized, count: itemUses.count, modelType: .header)
            data.append(header)
            data.append(contentsOf: itemUses as [Model])
        }
        let itemGrants = participant.itemGrants?.stats
            .map({ ItemStatsModel(name: $0.key, count: $0.value, modelType: .itemGrants) })
        if let itemGrants = itemGrants, itemGrants.count > 0 {
            let header = ItemStatsModel(name: "Purchased items".localized, count: itemGrants.count, modelType: .header)
            data.append(header)
            data.append(contentsOf: itemGrants as [Model])
        }
        let itemSells = participant.itemSells?.stats
            .map({ ItemStatsModel(name: $0.key, count: $0.value, modelType: .itemSells) })
        if let itemSells = itemSells, itemSells.count > 0 {
            let header = ItemStatsModel(name: "Sold items".localized, count: itemSells.count, modelType: .header)
            data.append(header)
            data.append(contentsOf: itemSells as [Model])
        }
        return data
    }
}

extension ParticipantDetailViewController: TableViewControllerDataSource {
    var _cellIdentifiers: [UITableViewCell.Type] {
        return [ParticipantTableViewCell.self, PlayerTableViewCell.self, UsedItemTableViewCell.self, HeaderTableViewCell.self]
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
            
            guard itemStatsModel.modelType != .header else {
                let cell = HeaderTableViewCell.dequeued(by: tableView)
                cell.update(with: itemStatsModel.name)
                return cell
            }
            let cell = UsedItemTableViewCell.dequeued(by: tableView)
            if let item = AppConfig.current.itemCatche.values
                .filter({ $0.itemStatsId?.contains(itemStatsModel.name) ?? false })
                .first {
                cell.update(
                    with: item.name ?? kEmptyStringValue,
                    imageString: item.url ?? kEmptyStringValue,
                    count: itemStatsModel.count,
                    type: itemStatsModel.modelType
                )
            } else {
                FirebaseHelper.storeUnknownItemIdentifier(itemIdentifier: itemStatsModel.name, isItemStatsId: true)
                cell.update(
                    with: itemStatsModel.name,
                    imageString: AppConfig.current.itemCatche.values.first?.url ?? "",
                    count: itemStatsModel.count,
                    type: itemStatsModel.modelType
                )
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func didSelect(_ model: Model, at indexPath: IndexPath) {
        
    }
}
