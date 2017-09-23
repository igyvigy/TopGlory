//
//  Side.swift
//  TG
//
//  Created by Andrii Narinian on 8/12/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

enum SideDir: String {
    case left, right, none
}

enum SideColor: String {
    case red, blue, none
    
    var uiColor: UIColor {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .none: return .clear
        }
    }
}

struct Side: Hashable {
    var dir: SideDir = .none
    var color: SideColor = .none
    
    init (identifier: String) {
        let components = identifier.components(separatedBy: "-")
        self.dir = SideDir(rawValue: components[0]) ?? .none
        self.color = SideColor(rawValue: components[1]) ?? .none
    }
    
    init (string: String?) {
        self.dir = string?.range(of: "left") != nil ? .left : .right
        self.color = string?.range(of: "blue") != nil ? .blue : .red
        guard let stringValue = string else { return }
        switch stringValue {
        case "1", "one", "left", "Left":
            self.dir = .left
            self.color = .blue
        case "2", "two", "right", "Right":
            self.dir = .right
            self.color = .red
        default: break
        }
    }
    
    var identifier: String {
        return "\(dir.r)-\(color.r)"
    }
    
    var damageColor: UIColor {
        switch dir {
        case .left: return TGColors.lightBlue
        case .right: return TGColors.lightRed
        default: return .white
        }
    }
    
    var turretKillColor: UIColor {
        switch dir {
        case .left: return TGColors.darkBlue
        case .right: return TGColors.darkRed
        default: return .white
        }
    }
    
    var hashValue: Int {
        return "\(dir)-\(color)".hashValue
    }
}

func == (lhs: Side, rhs: Side) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
