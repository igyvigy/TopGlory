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

    class func deploy(with matches: [Match], lastDate: Date, nextPageURL: String?, completion: MatchCompletion? = nil) -> MatchesViewController {
        let vc = MatchesViewController.instantiateFromStoryboardId(.main)
        vc.completionHandler = completion
        vc.matches = matches
        vc.nextPageURL = nextPageURL
        vc.lastDate = lastDate
        
        return vc
    }
    
    var completionHandler: MatchCompletion?
    var matches = [Match]() {
        didSet {
            guard tableView != nil else { return }
            tableView.reloadData()
        }
    }
    var nextPageURL: String?
    var lastDate = Date()
    var isLoading = false
    
    var completionForMatchLoad: (([Match]) -> Void)? {
        return { [unowned self] matches in
            self.matches.append(contentsOf: matches)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        dataSource = self
        delegate = self
        super.viewDidLoad()
        title = "\(AppConfig.currentUserName ?? "") · \(Shard(rawValue: AppConfig.currentShardId)?.name ?? "")"
        configurePullToRefresh(for: tableView, action: #selector(reloadMatches))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Hero.shared.containerColor = .black
        //Hero.shared.setContainerColorForNextTransition(.black)
    }
    
    func reloadMatches() {
        let date = Date()
        loadMatches(with: date) { [weak self] matches in
            self?.matches = matches
            self?.lastDate = date
        }
    }
    
    fileprivate func loadMatches(with date: Date, completion: (([Match]) -> Void)? = nil) {
        guard !isLoading else { return }
        isLoading = true
        
        VMatch.findWhere(withOwner: self, userName: AppConfig.currentUserName,
                         stardDate: Calendar.current.date(byAdding: DateComponents(day: -Constants.kNumberOfDaysToSearchMatches), to: date)!,
                         endDate: Calendar.current.date(byAdding: DateComponents(second: -1), to: date)!,
                         loaderMessage: "loading..", onSuccess: { [unowned self] matches, nextPageURL in
                            self.isLoading = false
                            self.stopRefreshing()
                            self.nextPageURL = nextPageURL
                            completion?(matches)
            }, onError: { [weak self] in
                self?.isLoading = false
                self?.stopRefreshing()
        })
    }
    
    fileprivate func loadMatches(with nextPageURL: String, completion: (([Match]) -> Void)? = nil) {
        guard !isLoading else { return }
        isLoading = true
        
        VMatch.findNext(withOwner: self, nextPageURL: nextPageURL, loaderMessage: "loading next..", control: nil, onSuccess: { [unowned self] matches, nextPageURL in
            self.isLoading = false
            self.stopRefreshing()
            self.nextPageURL = nextPageURL
            completion?(matches)
            }, onError: { [weak self] in
                self?.isLoading = false
                self?.stopRefreshing()
        })
    }
}

extension MatchesViewController: TableViewControllerDataSource {
    var _is5v5: Bool {
        return false
    }
    
    var _cellIdentifiers: [UITableViewCell.Type] {
        return [MatchTableViewCell.self, Match5TableViewCell.self, JSONModelTableViewCell.self]
    }
    
    var _tableView: UITableView {
        return tableView
    }
    
    var _models: [Model] {
        return matches
    }
}

extension MatchesViewController: TableViewControllerDelegate {
    func willDisplayLastRow() {
        if let nextPageURL = nextPageURL {
            loadMatches(with: nextPageURL, completion: completionForMatchLoad)
        } else {
            self.lastDate = Calendar.current.date(byAdding: DateComponents(day: -Constants.kNumberOfDaysToSearchMatches), to: self.lastDate)!
            loadMatches(with: self.lastDate, completion: completionForMatchLoad)
        }
    }
    
    func cell(for model: Model, at indexPath: IndexPath, is5v5: Bool) -> UITableViewCell? {
        let match = matches[indexPath.row]
        if match.is5v5 {
            let cell = Match5TableViewCell.dequeued(by: tableView)
            cell.update(with: match)
            return cell
        } else {
            let cell = MatchTableViewCell.dequeued(by: tableView)
            cell.update(with: match)
            return cell
        }
    }
    
    func didSelect(_ model: Model, at indexPath: IndexPath) {
        navigationController?.pushViewController(RostersViewController.deploy(with: matches[indexPath.row]), animated: true)
    }
}
