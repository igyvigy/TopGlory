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
        guard let name = playerTextField.text, name != "" else { return }
        saveLastPlayer(playerName: name)
        Match.findWhere(withOwner: self, userName: name, loaderMessage: "looking for your matches", control: sender, onSuccess: { [weak self] matches in
            let matchesVC = MatchesViewController.deploy(with: matches)
            self?.navigationController?.pushViewController(matchesVC, animated: true)
        })
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(false)
        didTapGoButton(goButton)
        return false
    }
}

