//
//  NumberExtension.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

extension Int {
    var secondsFormatted: String {
        let (h, m, s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        var output = ""
        if h > 0 { output += "\(h) Hours, "}
        output += "\(m) Minutes, \(s) Seconds"
        return output
    }
    var secondsFormattedShort: String {
        let (h, m, s) = (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
        var output = ""
        if h > 0 { output += "\(h) Hours, "}
        output += "\(m)m, \(s)s"
        return output
    }
}
