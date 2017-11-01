//
//  TGDates.swift
//  TG
//
//  Created by Andrii Narinian on 8/5/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import UIKit

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

enum DateFormatterType: String {
    case `default` = "yyyy-MM-dd HH:mm:ss ZZZZZ",
    weekDay = "EEEE",
    hourMinute = "HH:mm",
    ddMMyyyy = "dd/MM/yyyy",
    weekDayMonthDayHHmm = "EEE MMM d, HH:mm"
}

final class DateFormatterHelper {
    fileprivate static let formatter = DateFormatter()
    
    static func convertToDate(from string: String, with type: DateFormatterType = .default) -> Date? {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        formatter.dateFormat = type.r
        
        return formatter.date(from: string)
    }
    
    static func convertToString(from date: Date, with type: DateFormatterType = .default) -> String {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        formatter.dateFormat = type.r
        
        return formatter.string(from: date)
    }
    
    // MARK: - Custom
    
    static func chatMessageString(from string: String, with type: DateFormatterType) -> String? {
        guard let date = convertToDate(from: string, with: type) else { return nil }
        
        return chatMessageString(from: date)
    }
    
    static func chatMessageString(from date: Date) -> String {
        let currentDate = Date()
        let startOfCurrentWeek = currentDate.mondayOfWeek
        let startOfCurrentDay = currentDate.startOfDay
        let startOfCurrentDayDiff = date.timeIntervalSince(startOfCurrentDay)
        
        if startOfCurrentDayDiff > 0 {
            return convertToString(from: date, with: .hourMinute)
        } else if startOfCurrentDayDiff > -TimeInterval.day {
            return "Yesterday".localized
        }
        
        let startOfCurrentWeekDiff = date.timeIntervalSince(startOfCurrentWeek)
        
        if startOfCurrentWeekDiff > 0 {
            return convertToString(from: date, with: .weekDay)
        }
        
        return convertToString(from: date, with: .ddMMyyyy)
    }
    
    static func messageString(from string: String, with type: DateFormatterType) -> String? {
        guard let date = convertToDate(from: string, with: type) else { return nil }
        
        return messageString(from: date)
    }
    
    static func messageString(from date: Date) -> String {
        let currentDate = Date()
        let startOfCurrentWeek = currentDate.mondayOfWeek
        let startOfCurrentDay = currentDate.startOfDay
        let startOfCurrentDayDiff = date.timeIntervalSince(startOfCurrentDay)
        
        if startOfCurrentDayDiff > 0 {
            return "Today".localized + " " + convertToString(from: date, with: .hourMinute)
        }
        
        let startOfCurrentWeekDiff = date.timeIntervalSince(startOfCurrentWeek)
        
        if startOfCurrentWeekDiff > 0 {
            return convertToString(from: date, with: .weekDay) + " " + convertToString(from: date, with: .hourMinute)
        }
        
        return convertToString(from: date, with: .weekDayMonthDayHHmm)
    }
    
    static func getWeeksStringRange(for date: Date, with formatter: DateFormatterType = .ddMMyyyy) -> String {
        let monday = date.mondayOfWeek
        let sunday = date.sundayOfWeek
        
        if monday...sunday ~= Date() {
            return "This week"
        }
        
        let mondayStr = DateFormatterHelper.convertToString(from: monday, with: formatter)
        let sundayStr = DateFormatterHelper.convertToString(from: sunday, with: formatter)
        
        return mondayStr + "—" + sundayStr
    }
}
