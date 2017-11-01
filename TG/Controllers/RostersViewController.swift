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
    class func deploy(with match: Match, actionModels: [FActionModel]? = nil, completion: RosterCompletion? = nil) -> RostersViewController {
        let vc = RostersViewController.instantiateFromStoryboardId(.main)
        vc.completionHandler = completion
        vc.match = match
        var models = [Model]()
        match.rosters.forEach({ roster in
            models.append(roster)
            roster.participants?.forEach({ participant in
                models.append(participant)
            })
        })
        vc.models = models
        vc.actionModels = actionModels
        return vc
    }
    
    var completionHandler: RosterCompletion?
    var match: Match!
    var models: [Model]!
    var actionModels: [FActionModel]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        dataSource = self
        delegate = self
        super.viewDidLoad()
        title = match.description
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "kills graph", style: .plain, target: self, action: #selector(showTelemetry(sender:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Hero.shared.setContainerColorForNextTransition(.black)
    }
    
    @IBAction func showTelemetry(sender: UIBarButtonItem) {
        guard let asset = match.assets.first else { return }
        sender.isEnabled = false
        navigationController?.showLoader(message: "loading graph data")
        
        asset.loadTelemetry(withOwner: self, loaderMessage: nil, control: sender, onSuccess: { [weak self] actions in
            guard let match = self?.match else { return }
            let graphVC = GraphViewController.deploy(with: actions, match: match)
            DispatchQueue.main.async {
                sender.isEnabled = true
                self?.navigationController?.hideCurrentWhisper()
                self?.navigationController?.pushViewController(graphVC, animated: true)
            }
            
        })
        
    }
}

extension RostersViewController: TableViewControllerDataSource {
    var _cellIdentifiers: [UITableViewCell.Type] {
        return [RosterTableViewCell.self, ParticipantCell.self]
    }
    
    var _tableView: UITableView {
        return tableView
    }
    
    var _models: [Model] {
        return actionModels ?? models
    }
}

extension RostersViewController: TableViewControllerDelegate {
    func willDisplayLastRow() {
        
    }

    func cell(for model: Model, at indexPath: IndexPath) -> UITableViewCell? {
        if model is Roster {
            let cell = RosterTableViewCell.dequeued(by: tableView)
            cell.update(with: model as? Roster)
            return cell
        }
        if model is Participant {
            let cell = ParticipantCell.dequeued(by: tableView)
            cell.update(with: model as? Participant)
            return cell
        }
        if model is FActionModel {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.text = "\((model as? FActionModel)?.action ?? ActionType.Unknown)"
            cell.textLabel?.numberOfLines = 0
            return cell
        }
        return UITableViewCell()
    }
    
    func didSelect(_ model: Model, at indexPath: IndexPath) {
        guard let participant = models[safe: indexPath.row] as? Participant, actionModels == nil else {
            return
        }
        navigationController?.pushViewController(ParticipantDetailViewController.deploy(with: participant), animated: true)
    }
}
