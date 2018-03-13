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
    
    var titleView = UILabel()
    var isLoading = false {
        didSet {
            playerTextField.isEnabled = !self.isLoading
        }
    }
    var selectedRegion = "" {
        didSet{
            titleView.frame.size.width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
            
            titleView.text = Shard(rawValue: selectedRegion)?.name
            UserDefaults.standard.set(selectedRegion, forKey: Constants.shardDefaultsKey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        AppConfig.current.fetchData { [unowned self] in
            self.goButton.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Hero.shared.setContainerColorForNextTransition(.black)
    }
    
    private func configure() {
        goButton.isEnabled = false
        navigationController?.hero.isEnabled = true
        navigationController?.hero.navigationAnimationType = .selectBy(presenting:.zoom, dismissing:.zoomOut)
        playerTextField.delegate = self
        if let playerName = AppConfig.currentUserName {
            playerTextField.text = playerName
        }
        configureUI()
    }
    
    func configureUI() {
        initNavigationItemTitleView()
    }
    
    private func initNavigationItemTitleView() {
        selectedRegion = AppConfig.currentShardId
        titleView.text = Shard(rawValue: selectedRegion)?.name
        titleView.textAlignment = .center
        titleView.font = UIFont(name: "HelveticaNeue-Medium", size: 17)
        titleView.textColor = alertTintColorConstant
        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        titleView.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: width, height: 500))
        self.navigationItem.titleView = titleView
        titleView.textColor = .white
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(titleWasTapped))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
    }
    
    @objc private func titleWasTapped() {
        guard !isLoading else { return }
        let picker = UIPickerView(frame: .zero)
        picker.delegate = self
        picker.dataSource = self
        picker.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint: NSLayoutConstraint = NSLayoutConstraint(item: picker, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 300)
        picker.addConstraint(heightConstraint)
        
        for (index, shard) in Shard.cases().enumerated() {
            if shard.r == selectedRegion {
                picker.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        let ac = UIAlertController(title: "select region", message: nil, preferredStyle: .alert)
        ac.popoverPresentationController?.sourceView = view
        ac.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 30, height: 30)
        ac.view.superview?.backgroundColor = .clear
        ac.addAction(UIAlertAction(title: "✔︎", style: .default, handler: { [unowned self] _ in
            self.selectedRegion = Array(Shard.cases())[picker.selectedRow(inComponent: 0)].r
        }))
        ac.addAction(UIAlertAction(title: "✖︎", style: .destructive, handler: { _ in }))
        
        ac.view.addSubview(picker)
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["picker"] = picker
        ac.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[picker]|", metrics: nil, views: viewBindingsDict))
        ac.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[picker]-30-|", metrics: nil, views: viewBindingsDict))
        
        present(ac, animated: true) {}
    }
    
    fileprivate func saveLastPlayer(playerName: String?) {
        UserDefaults.standard.set(playerName, forKey: Constants.lastUserDefaultsKey)
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(Shard.cases())[row].name
    }
}

extension ViewController: UIPickerViewDataSource {
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Array(Shard.cases()).count
    }

    
}

extension ViewController {
    fileprivate func getMatches(name: String, sender: UIControl, date: Date) {
        VMatch.findWhere(withOwner: self, userName: name,
                         stardDate: Calendar.current.date(byAdding: DateComponents(day: -Constants.kNumberOfDaysToSearchMatches), to: date)!,
                         endDate: Calendar.current.date(byAdding: DateComponents(second: -1), to: date)!,
                         loaderMessage: "looking for your matches", control: sender, onSuccess: { [weak self] matches, nextPageURL in
                            let matchesVC = MatchesViewController.deploy(with: matches, lastDate: date, nextPageURL: nextPageURL)
                            self?.isLoading = false
                            self?.navigationController?.pushViewController(matchesVC, animated: true)
            }, onError: { [weak self] in
                self?.isLoading = false
        })
    }
    
    @IBAction func didTapGoButton(_ sender: UIButton) {
        guard !isLoading else { return }
        isLoading = true
        guard let name = playerTextField.text, name != "", AppConfig.current.finishedToFetchData else { return }
        saveLastPlayer(playerName: name)

        getMatches(name: name, sender: sender, date: Date())
        
//        FirebaseHelper.createRecordsForKnownItems()
        
//        VMatch.findWhere(withOwner: self, userName: name,
//                         loaderMessage: "looking for your matches", control: sender, onSuccess: { [weak self] matches in
//            FirebaseHelper.getAllDIfferentMatchesFromHistory(for: matches, completion: { [weak self] matchesFormHistory in
//                var summ = matches
//                summ.append(contentsOf: matchesFormHistory.sorted())
//                let matchesVC = MatchesViewController.deploy(with: matches)
//                self?.navigationController?.pushViewController(matchesVC, animated: true)
//            })
//        })
        
//        VMatch.findWhere(
//            withOwner: self,
//            userName: name,
//            stardDate: Calendar.current.date(byAdding: DateComponents(day: -35), to: Date())!,
//            endDate: Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!,
//            loaderMessage: "getting matches from start of the year",
//            control: sender,
//            onSuccess: { [weak self] matches in
//                let matchesVC = MatchesViewController.deploy(with: matches)
//                self?.navigationController?.pushViewController(matchesVC, animated: true)
////                matches.forEach { match in
////                    match.rosters.forEach { roster in
////                        roster.participants.forEach {
////                            let _ = $0.skin
////                        }
////                    }
//////                    match.assets.forEach { asset in
//////                        asset.loadTelemetry(onSuccess: { actionModels in
//////                            let _ = actionModels.map({ $0.action }).filter({ $0?.id == "UseAbility" })
//////                        })
//////                    }
////                }
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

