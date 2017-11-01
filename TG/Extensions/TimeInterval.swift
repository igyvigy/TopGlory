//
//  TimeInterval.swift
//  TG
//
//  Created by Andrii Narinian on 11/1/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

extension TimeInterval {
    static var minute: TimeInterval {
        return 60
    }
    
    static var hour: TimeInterval {
        return minute * 60
    }
    
    static var day: TimeInterval {
        return hour * 24
    }
    
    static var week: TimeInterval {
        return day * 7
    }
    
    static var notLeapYear: TimeInterval {
        return day * 365
    }
    
    static var leapYear: TimeInterval {
        return day * 366
    }
}
