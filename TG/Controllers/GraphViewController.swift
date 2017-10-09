//
//  GraphViewController.swift
//  TG
//
//  Created by Andrii Narinian on 8/12/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit
import Hero
import Charts

class GraphViewController: UIViewController {
    class func deploy(with actions: [Action]? = nil, match: Match) -> GraphViewController {
        let vc = GraphViewController.instantiateFromStoryboardId(.main)
        vc.actions = actions
        vc.match = match
        return vc
    }
    @IBOutlet weak var chartView: LineChartView!
    var match: Match!
    var actions: [Action]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.backgroundColor = .black
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .white
        chartView.leftAxis.labelTextColor = .yellow
        chartView.leftAxis.axisLineColor = .white
        chartView.legend.textColor = .white
        makeData()
    }
    
    func makeData() {
        let teamKills = makeTeamKillsData()
        //let turretKills = makeTeamTurretKillsData()
        //let teamDamage = makeTeamDamageData()
        chartView.data = LineChartData(dataSets: teamKills)// + turretKills + teamDamage)
    }
    
    func makeTeamKillsData() -> [LineChartDataSet] {
        var teamKillsData = [Side: [(Date, Int)]]()
        var teamsKillCounter = [Side: Int]()
        
        actions?.filter({ $0.actionId == "KillActor" }).forEach { action in
            let targetIsHero = (action.payload?["TargetIsHero"] as? Int ?? 0)
            let side = Side(string: action.payload?["Team"] as? String ?? "")
            if targetIsHero == 1 {
                if let kills = teamsKillCounter[side] {
                    teamKillsData[side]?.append((action.time!, kills + 1))
                    teamsKillCounter[side] = kills + 1
                } else {
                    teamKillsData[side] = [(Date, Int)]()
                    teamKillsData[side]?.append((action.time!.addingTimeInterval(-1), 0))
                    teamKillsData[side]?.append((action.time!, 1))
                    teamsKillCounter[side] = 1
                }
            }
        }
        
        var dataSets = [LineChartDataSet]()
        teamKillsData.keys.forEach { side in
            if let kills: [(Date, Int)] = teamKillsData[side] {
                var dataPoints: [Int] {
                    return kills.map({ Int($0.0.timeIntervalSince(match.createdAt ?? Date())) })
                }
                var values: [Double] {
                    return kills.map({ Double($0.1) })
                }
                print("setChart: \n dataPoints: \(dataPoints) \n values: \(values)")
                dataSets.append(createLineChardDataSet(dataPoints: dataPoints, values: values, side: side, text: "team kills", color: side.color.uiColor, lineWidth: 3))
            }
        }
        return dataSets
    }
    
    func makeTeamTurretKillsData() -> [LineChartDataSet] {
        var teamKillsData = [Side: [(Date, Int)]]()
        var teamsKillCounter = [Side: Int]()
        
        actions?.filter({ $0.actionId == "KillActor" }).forEach { action in
            let targetIsHero = (action.payload?["TargetIsHero"] as? Int ?? 0)
            let side = Side(string: action.payload?["Team"] as? String ?? "")
            let killed = Actor(id: action.payload?["Killed"] as? String ?? "", type: .actor)
            if killed.id == "*Turret*" || killed.id == "*VainTurret*" {
                if let kills = teamsKillCounter[side] {
                    teamKillsData[side]?.append((action.time!, kills + 1))
                    teamsKillCounter[side] = kills + 1
                } else {
                    teamKillsData[side] = [(Date, Int)]()
                    teamKillsData[side]?.append((action.time!.addingTimeInterval(-1), 0))
                    teamKillsData[side]?.append((action.time!, 1))
                    teamsKillCounter[side] = 1
                }
            }
        }

        
        var dataSets = [LineChartDataSet]()
        teamKillsData.keys.forEach { side in
            if let kills: [(Date, Int)] = teamKillsData[side] {
                var dataPoints: [Int] {
                    return kills.map({ Int($0.0.timeIntervalSince(match.createdAt ?? Date())) })
                }
                var values: [Double] {
                    return kills.map({ Double($0.1) })
                }
                print("setChart: \n dataPoints: \(dataPoints) \n values: \(values)")
                let dataSet = createLineChardDataSet(dataPoints: dataPoints, values: values, side: side, text: "team turrets", color: side.turretKillColor, lineWidth: 5)
                dataSets.append(dataSet)
            }
        }
        return dataSets
    }
    
    func makeTeamDamageData() -> [LineChartDataSet] {
        var teamDamageData = [Side: [(Date, Double)]]()
        
        actions?.filter({ $0.id == "DealDamage" }).forEach { action in
            switch action {
//            case .DealDamage(let time, let side, let actor, let target, let source, let damage, let delt, let isHero, let targetIsHero):
//                let delt: Double = (Double(delt)/100)
//                if targetIsHero {
//                    if let _ = teamDamageData[side] {
//                        teamDamageData[side]?.append((time, delt))
//                    } else {
//                        teamDamageData[side] = [(Date, Double)]()
//                        teamDamageData[side]?.append((time, delt))
//                    }
//                    teamDamageData[side]?.append((time, delt))
//                }
            default: break
            }
        }
        var dataSets = [LineChartDataSet]()
        teamDamageData.keys.forEach { side in
            if let damage: [(Date, Double)] = teamDamageData[side] {
                var dataPoints: [Int] {
                    return damage.map({ Int($0.0.timeIntervalSince(match.createdAt ?? Date())) })
                }
                var values: [Double] {
                    return damage.map({ Double($0.1) })
                }
                print("setChart: \n dataPoints: \(dataPoints) \n values: \(values)")
                let dataSet = createLineChardDataSet(dataPoints: dataPoints, values: values, side: side, text: "team damage", color: side.damageColor, lineWidth: 1)
                dataSet.mode = .cubicBezier
                dataSet.fill = Fill(color: side.damageColor)
                dataSets.append(dataSet)
            }
        }
        return dataSets
    }
    
    func createLineChardDataSet(dataPoints: [Int], values: [Double], side: Side, text: String, color: UIColor, lineWidth: CGFloat) -> LineChartDataSet {
        var dataEntries: [ChartDataEntry] = []
        let matchSecondsLength = match.duration ?? 0
        for x in 0..<matchSecondsLength {
            if dataPoints.contains(x) {
                let dataEntry = ChartDataEntry(x: Double(x), y: values[dataPoints.index(of: x)!], icon: nil)
                dataEntries.append(dataEntry)
            }
        }
        
        let dataSet = LineChartDataSet(values: dataEntries, label: "\(side.dir) \(text)")
        dataSet.colors = [color]
        dataSet.setCircleColor(.clear)
        dataSet.circleHoleRadius = 0
        dataSet.cubicIntensity = 0.2
        dataSet.lineWidth = lineWidth
        dataSet.valueColors = [.white]
        return dataSet
    }
}
