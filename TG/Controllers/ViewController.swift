//
//  ViewController.swift
//  TG
//
//  Created by Andrii Narinian on 7/10/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import Hero

class ViewController: UIViewController {
    @IBOutlet weak var playerTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        AppConfig.current.fetchData {}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Hero.shared.setContainerColorForNextTransition(.black)
    }
    
    private func configure() {
        navigationController?.isHeroEnabled = true
        navigationController?.heroNavigationAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
        playerTextField.delegate = self
        if let playerName = AppConfig.currentUserName {
            playerTextField.text = playerName
        }
    }
    
    fileprivate func saveLastPlayer(playerName: String?) {
        UserDefaults.standard.set(playerName, forKey: Constants.lastUserDefaultsKey)
    }
}

extension ViewController {
    @IBAction func didTapGoButton(_ sender: UIButton) {
        guard let name = playerTextField.text, name != "", AppConfig.current.finishedToFetchData else { return }
        saveLastPlayer(playerName: name)
//        FirebaseHelper.createRecordsForKnownSkins()
//        FirebaseHelper.createRecordsForKnownActors()
//        FirebaseHelper.createRecordsForKnownItems()
        FirebaseHelper.getAllSkins { skins in
            dump(skins)
        }
        VMatch.findWhere(withOwner: self, userName: name, loaderMessage: "looking for your matches", control: sender, onSuccess: { [weak self] matches in
            let matchesVC = MatchesViewController.deploy(with: matches)
            self?.navigationController?.pushViewController(matchesVC, animated: true)
        })
        
//        Match.findWhere(
//            withOwner: self,
//            userName: name,
//            stardDate: Calendar.current.date(byAdding: DateComponents(day: -35), to: Date())!,
//            endDate: Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!,
//            loaderMessage: "getting matches from start of the year",
//            control: sender,
//            onSuccess: { matches in
//                matches.forEach { match in
//                    match.rosters.forEach { roster in
//                        roster.participants.forEach {
//                            let _ = $0.skin
//                        }
//                    }
////                    match.assets.forEach { asset in
////                        asset.loadTelemetry(onSuccess: { actionModels in
////                            let _ = actionModels.map({ $0.action }).filter({ $0?.id == "UseAbility" })
////                        })
////                    }
//                }
//        })
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(false)
        didTapGoButton(goButton)
        return false
    }
}

