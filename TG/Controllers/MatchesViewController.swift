//
//  MatchesViewController.swift
//  TopGlory
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import Hero

class MatchesViewController: TableViewController {
    class func deploy(with matches: [Match], completion: MatchCompletion? = nil) -> MatchesViewController {
        let vc = MatchesViewController.instantiateFromStoryboardId(.main)
        vc.completionHandler = completion
        vc.matches = matches
        return vc
    }
    
    var completionHandler: MatchCompletion?
    var matches = [Match]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        dataSource = self
        delegate = self
        super.viewDidLoad()
        title = "\(AppConfig.currentUserName ?? "") · last 24 hours"
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
