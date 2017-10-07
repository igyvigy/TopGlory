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
    var imageData: [String] { get }
    
    var modelData: [Model] { get }
    var stringData: [String] { get }
    
    func getArray() -> [SectionData]?
}

extension SectionData {
    var titleData: [String] { return [String]() }
    var detailData: [String] { return [String]() }
    var imageData: [String] { return [String]() }
    var modelData: [Model] { return [Model]() }
    var stringData: [String] { return [String]() }
    func getArray() -> [SectionData]? {
        return nil
    }
}

enum ViewControllerMode {
    case skins, actors, items, gameModes, newSkins, newActors, newItemImages, newItemIds, newGameModes
    
    var modelType: ModelType {
        switch self {
        case .skins: return .skin
        case .actors: return .actor
        case .items: return .item
        case .gameModes: return .gamemode
        case .newSkins: return .skin
        case .newActors: return .actor
        case .newItemImages: return .item
        case .newItemIds: return .item
        case .newGameModes: return .gamemode
        }
    }

    var data: SectionData {
    
        switch self {
        case .skins:
            struct Data: SectionData {
                var titleData: [String] { return AppConfig.current.skins.map { $0.name ?? "" } }
                var detailData: [String] { return AppConfig.current.skins.map { $0.id ?? "" } }
                var imageData: [String] { return AppConfig.current.skins.map { $0.url ?? "" } }
                var modelData: [Model] { return AppConfig.current.skins }
            }
            
            return Data()
        case .actors:
            struct Data: SectionData {
                var titleData: [String] { return AppConfig.current.actors.map { $0.name ?? "" } }
                var detailData: [String] { return AppConfig.current.actors.map { $0.id ?? "" } }
                var imageData: [String] { return AppConfig.current.actors.map { $0.url ?? "" } }
                var modelData: [Model] { return AppConfig.current.actors }
            }
            
            return Data()
        case .items:
            struct Data: SectionData {
                var titleData: [String] { return AppConfig.current.items.map { $0.name ?? "" } }
                var detailData: [String] { return AppConfig.current.items.map { $0.id ?? "" } }
                var imageData: [String] { return AppConfig.current.items.map { $0.url ?? "" } }
                var modelData: [Model] { return AppConfig.current.items }
            }
            
            return Data()
        case .gameModes:
            struct Data: SectionData {
                var titleData: [String] { return AppConfig.current.gameModes.map { $0.name ?? "" } }
                var detailData: [String] { return AppConfig.current.gameModes.map { $0.id ?? "" } }
                var modelData: [Model] { return AppConfig.current.gameModes }
            }
            
            return Data()
        case .newSkins:
            struct Data: SectionData {
                var titleData: [String] { return AppConfig.current.newSkins.map { $0 } }
                var stringData: [String] { return AppConfig.current.newSkins }
            }
            
            return Data()
        case .newActors:
            struct Data: SectionData {
                var titleData: [String] { return AppConfig.current.newActors.map { $0 } }
                var stringData: [String] { return AppConfig.current.newActors }
            }
            
            return Data()
        case .newItemImages:
            struct Data: SectionData {
                var titleData: [String] { return AppConfig.current.newItemImages.map { $0 } }
                var stringData: [String] { return AppConfig.current.newItemImages }
            }
            return Data()
        case .newItemIds:
            struct Data: SectionData {
                var titleData: [String] { return AppConfig.current.newItemIds.map { $0 } }
                var stringData: [String] { return AppConfig.current.newItemIds }
            }
            
            return Data()
        case .newGameModes:
            struct Data: SectionData {
                var titleData: [String] { return AppConfig.current.newGameModes.map { $0 } }
                var stringData: [String] { return AppConfig.current.newGameModes }
            }
            
            return Data()
        }
    }
}

class ViewController: UIViewController {
    class func deploy(mode: ViewControllerMode?) -> ViewController {
        let vc = ViewController.instantiateFromStoryboardId(.main)
        vc.mode = mode
        return vc
    }
    
    var mode: ViewControllerMode?
    
    @IBOutlet weak var tableView: UITableView!
    
    struct AddData: SectionData {
        var titleData: [String] {
            return ["Skins", "Actors", "Item Images", "Item Stats Id", "Game Modes"]
        }
        var detailData: [String] {
            return ["\(AppConfig.current.skinUnknownCatche.keys.count) to add",
                "\(AppConfig.current.actorUnknownCatche.keys.count) to add",
                "\(AppConfig.current.itemUnknownImageCatche.keys.count) to add",
                "\(AppConfig.current.itemUnknownIdentifierCatche.keys.count) to add",
                "\(AppConfig.current.gameModeUnknownCatche.keys.count) to add"
            ]
        }
    }
    
    struct EditData: SectionData {
        var titleData: [String] {
            return ["Skins", "Actors", "Items", "Game Modes"]
        }
        var detailData: [String] {
            return ["\(AppConfig.current.skinCatche.values.count) total",
                "\(AppConfig.current.actorCatche.values.count) total",
                "\(AppConfig.current.itemCatche.values.count) total",
                "\(AppConfig.current.gameModeCatche.values.count) total"
            ]
        }
    }
    
    var tableData: [SectionData] {
        guard let mode = mode else { return [AddData(), EditData()] }
        
        return [mode.data]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if mode == nil {
            fullReload()
        }
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
    }
    
    fileprivate func fullReload() {
        AppConfig.current.fetchAll { [unowned self] in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func presentItemStatsInserter(with id: String) {
        MultiActionAlert(
            style: .actionSheet,
            title: id,
            buttonTitles: AppConfig.current.items.map { $0.name ?? $0.id ?? "" } + ["Cancel"],
            actionStyles: AppConfig.current.items.map { _ in .default } + [.cancel],
            actions: AppConfig.current.items.map { item -> () -> Void in
                return { [unowned self] _ in
                    item.itemStatsId = id
                    FirebaseHelper.store(models: [item])
                    FirebaseHelper.removeUnknownRecordForMode(model: Model(id: id, type: .item), isItemStatsId: true)
                    self.fullReload()
                }
                } + [{}],
            owner: self,
            textfieldConfigurationHandler: nil).showAlert()
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
        cell.textLabel?.text = sectionData.titleData[safe: indexPath.row]
        cell.detailTextLabel?.text = sectionData.detailData[safe: indexPath.row]
        cell.imageView?.image = nil
        let urlString = sectionData.imageData[safe: indexPath.row] ?? ""
        if let url = URL(string: urlString) {
            cell.imageView?.setImage(withURL: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return tableData.count > 1 ? "Add New" : nil }
        if section == 1 { return tableData.count > 1 ? "Edit Old" : nil }
        return nil
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if mode == nil {
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    navigationController?.pushViewController(ViewController.deploy(mode: .skins), animated: true)
                } else if indexPath.row == 1 {
                    navigationController?.pushViewController(ViewController.deploy(mode: .actors), animated: true)
                } else if indexPath.row == 2 {
                    navigationController?.pushViewController(ViewController.deploy(mode: .items), animated: true)
                } else if indexPath.row == 3 {
                    navigationController?.pushViewController(ViewController.deploy(mode: .gameModes), animated: true)
                }
            } else if indexPath.section == 0 {
                if indexPath.row == 0 {
                    navigationController?.pushViewController(ViewController.deploy(mode: .newSkins), animated: true)
                } else if indexPath.row == 1 {
                    navigationController?.pushViewController(ViewController.deploy(mode: .newActors), animated: true)
                } else if indexPath.row == 2 {
                    navigationController?.pushViewController(ViewController.deploy(mode: .newItemImages), animated: true)
                } else if indexPath.row == 3 {
                    navigationController?.pushViewController(ViewController.deploy(mode: .newItemIds), animated: true)
                } else if indexPath.row == 4 {
                    navigationController?.pushViewController(ViewController.deploy(mode: .newGameModes), animated: true)
                }
            }
        } else {
            let mode = self.mode!
            var model: Model?
            var id: String?
            var itemStatId: String?
            switch mode {
            case .actors, .gameModes, .items, .skins:
                model = mode.data.modelData[safe: indexPath.row]
            case .newItemIds:
                itemStatId = mode.data.stringData[safe: indexPath.row]
            case .newGameModes, .newItemImages, .newActors, .newSkins:
                id = mode.data.stringData[safe: indexPath.row]
            }
            if let itemStatId = itemStatId {
                presentItemStatsInserter(with: itemStatId)
                
                return
            } else if let id = id {
                model = Model(id: id, type: mode.modelType)
            }
            guard let mdl = model else { return }
            present(EditViewController.deploy(with: mode, model: mdl, completion: { [unowned self] editVC in
                if editVC?.changed ?? false {
                    self.fullReload()
                }
            }), animated: true)
        }
    }
}
