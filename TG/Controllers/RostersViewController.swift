//
//  RostersViewController.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import Hero

class RostersViewController: TableViewController {
    class func deploy(with match: Match, completion: RosterCompletion? = nil) -> RostersViewController {
        let vc = RostersViewController.instantiateFromStoryboardId(.main)
        vc.completionHandler = completion
        vc.match = match
        var models = [Model]()
        match.rosters.forEach({ roster in
            models.append(roster)
            roster.participants.forEach({ participant in
                models.append(participant)
            })
        })
        vc.models = models
        return vc
    }
    
    var completionHandler: RosterCompletion?
    var match: Match!
    var models: [Model]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        super.viewDidLoad()
        title = match.description
    }
}

extension RostersViewController: TableViewControllerDataSource {
    var _cellIdentifiers: [UITableViewCell.Type] {
        return [RosterTableViewCell.self, ParticipantTableViewCell.self]
    }
    
    var _tableView: UITableView {
        return tableView
    }
    
    var _models: [Model] {
        return models
    }
}

extension RostersViewController: TableViewControllerDelegate {
    func cell(for model: Model, at indexPath: IndexPath) -> UITableViewCell? {
        if model is Roster {
            let cell = RosterTableViewCell.dequeued(by: tableView)
            cell.update(with: model as? Roster)
            return cell
        } else {
            let cell = ParticipantTableViewCell.dequeued(by: tableView)
            cell.update(with: model as? Participant, showPlayer: true)
            return cell
        }
    }
    
    func didSelect(_ model: Model, at indexPath: IndexPath) {
        guard let participant = models[indexPath.row] as? Participant else {
            return
        }
        navigationController?.pushViewController(ParticipantDetailViewController.deploy(with: participant), animated: true)
    }
}
