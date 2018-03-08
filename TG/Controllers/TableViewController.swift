//
//  TableViewController.swift
//  TG
//
//  Created by Andrii Narinian on 7/14/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

protocol TableViewControllerDataSource: class {
    var _tableView: UITableView { get }
    var _models: [Model] { get }
    var _cellIdentifiers: [UITableViewCell.Type] { get }
    var _is5v5: Bool { get }
}

protocol TableViewControllerDelegate: class {
    func didSelect(_ model: Model, at indexPath: IndexPath)
    func cell(for model: Model, at indexPath: IndexPath, is5v5: Bool) -> UITableViewCell?
    func willDisplayLastRow()
}

class TableViewController: UIViewController {
    weak var dataSource: TableViewControllerDataSource?
    weak var delegate: TableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tableView = dataSource?._tableView else { return }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 329
        guard let cells = dataSource?._cellIdentifiers else { return }
        tableView.register(cells)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dataSource?._tableView.visibleCells.forEach({ cell in
            if let cell = cell as? TGTableViewCell {
                cell.viewDidLayoutSubviews()
            }
        })
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = dataSource?._models[indexPath.row] {
            delegate?.didSelect(model, at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (dataSource?._models.count ?? 0) - 1 {
            delegate?.willDisplayLastRow()
        }
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?._models.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let model = dataSource?._models[indexPath.row] {
            return delegate?.cell(for: model, at: indexPath, is5v5: dataSource?._is5v5 ?? false) ?? UITableViewCell()
        }
        return UITableViewCell()
    }
}
