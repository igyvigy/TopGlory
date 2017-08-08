//
//  MatchesViewController.swift
//  TopGlory
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import Hero

class MatchesViewController: TableViewController, Refreshable {
    lazy var refreshControl: UIRefreshControl = { UIRefreshControl() }()

    class func deploy(with matches: [Match], completion: MatchCompletion? = nil) -> MatchesViewController {
        let vc = MatchesViewController.instantiateFromStoryboardId(.main)
        vc.completionHandler = completion
        vc.matches = matches
        return vc
    }
    
    var completionHandler: MatchCompletion?
    var matches = [Match]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        dataSource = self
        delegate = self
        super.viewDidLoad()
        title = "\(AppConfig.currentUserName ?? "") · last 24 hours"
        configurePullToRefresh(for: tableView, action: #selector(loadMatches))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Hero.shared.setContainerColorForNextTransition(.black)
    }
    
    func loadMatches() {
        Match.findWhere(withOwner: self, userName: AppConfig.currentUserName, onSuccess: { [weak self] matches in
            self?.matches = matches
        })
    }
}

extension MatchesViewController: TableViewControllerDataSource {
    var _cellIdentifiers: [UITableViewCell.Type] {
        return [MatchTableViewCell.self, JSONModelTableViewCell.self]
    }

    var _tableView: UITableView {
        return tableView
    }
    
    var _models: [Model] {
        return matches
    }
}

extension MatchesViewController: TableViewControllerDelegate {
    func cell(for model: Model, at indexPath: IndexPath) -> UITableViewCell? {
        let cell = MatchTableViewCell.dequeued(by: tableView)
        cell.update(with: matches[indexPath.row])
        return cell
    }

    func didSelect(_ model: Model, at indexPath: IndexPath) {
        navigationController?.pushViewController(RostersViewController.deploy(with: matches[indexPath.row]), animated: true)
    }
}
