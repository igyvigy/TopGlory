//
//  TGDates.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

enum TGDates {
    case beginningOfDay, startOfYear, endOfYear, startOfMonth, endOfMonth, last24Hours, lastWeek
    
    func getDate(for date: Date) -> Date {
        switch self {
        case .beginningOfDay:
            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            components.hour = 0
            components.minute = 1
            return Calendar.current.date(from: components)!
        case .last24Hours:
            return Calendar.current.date(byAdding: DateComponents(day: -1), to: date)!
        case .lastWeek:
            return Calendar.current.date(byAdding: DateComponents(day: -7), to: date)!
        case .startOfYear:
            var components = Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: date))
            components.hour = 0
            components.minute = 1
            return Calendar.current.date(from: components)!
        case .endOfYear:
            return Calendar.current.date(byAdding: DateComponents(day: -1, hour: 23, minute: 58), to: TGDates.startOfYear.getDate(for: date))!
        case .startOfMonth:
            var components = Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: date))
            components.hour = 0
            components.minute = 1
            return Calendar.current.date(from: components)!
        case .endOfMonth:
            return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1, hour: 23, minute: 58), to: TGDates.startOfMonth.getDate(for: date))!
        }
    }
    
    var now: Date {
        return getDate(for: Date())
    }
}

// MARK: TGDateFormats
struct TGDateFormats {
    static var dateAndTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter
    }
    
    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    static var iso8601: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter
    }
    
    static var iso8601WithoutTimeZone: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }
}
