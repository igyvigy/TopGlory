//
//  TableViewController.swift
//  TGContentManager
//
//  Created by Andrii Narinian on 9/22/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

protocol SectionData {
    var titleData: [String] { get }
    var detailData: [String] { get }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    struct AddData: SectionData {
        var detailData: [String] {
            return ["1 to add", "2 to add", "3 to add", "4 to add", "5 to add"]
        }

        var titleData: [String] {
            return ["Skins", "Actors", "Item Images", "Item Stats Id", "Game Modes"]
        }
    }
    
    struct EditData: SectionData {
        var detailData: [String] {
            return ["1 total", "2 total", "3 total", "4 total"]
        }
        
        var titleData: [String] {
            return ["Skins", "Actors", "Items", "Game Modes"]
        }
    }
    
    var tableData: [SectionData] = [AddData(), EditData()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].titleData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionData = tableData[indexPath.section]
        cell.textLabel?.text = sectionData.titleData[indexPath.row]
        cell.detailTextLabel?.text = sectionData.detailData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Add New" }
        if section == 1 { return "Edit Old" }
        return nil
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
