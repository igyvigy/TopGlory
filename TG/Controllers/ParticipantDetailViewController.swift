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
        return [participant.player!, participant]
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
        return [ParticipantTableViewCell.self, PlayerTableViewCell.self]
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
        return UITableViewCell()
    }
    
    func didSelect(_ model: Model, at indexPath: IndexPath) {
        
    }
}
